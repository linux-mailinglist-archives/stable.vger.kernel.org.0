Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C226F39FFAE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhFHSfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234629AbhFHSdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C51F613BE;
        Tue,  8 Jun 2021 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177080;
        bh=Q+B/uVpWs0oT3LLbwGd7o7GS1/qIOetT+U4smrP+HTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKvHiH52521BxhafqmKsHcOUePjDK651W++zGsc2jDj0eX9zawzO9nmJy80pS6qeA
         wxsUzxmLIvwfC3lrKJv7ncCe8JVxY3tDRs/eW6zEMtIKPQxkXKTpZ3Ex5h86ObhHa2
         w8elkg3QtZQWJXEkzkkZHzKqjlaSQtkgI9+zCFDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 25/47] btrfs: fixup error handling in fixup_inode_link_counts
Date:   Tue,  8 Jun 2021 20:27:08 +0200
Message-Id: <20210608175931.305692212@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 011b28acf940eb61c000059dd9e2cfcbf52ed96b upstream.

This function has the following pattern

	while (1) {
		ret = whatever();
		if (ret)
			goto out;
	}
	ret = 0
out:
	return ret;

However several places in this while loop we simply break; when there's
a problem, thus clearing the return value, and in one case we do a
return -EIO, and leak the memory for the path.

Fix this by re-arranging the loop to deal with ret == 1 coming from
btrfs_search_slot, and then simply delete the

	ret = 0;
out:

bit so everybody can break if there is an error, which will allow for
proper error handling to occur.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1558,6 +1558,7 @@ static noinline int fixup_inode_link_cou
 			break;
 
 		if (ret == 1) {
+			ret = 0;
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
@@ -1570,17 +1571,19 @@ static noinline int fixup_inode_link_cou
 
 		ret = btrfs_del_item(trans, root, path);
 		if (ret)
-			goto out;
+			break;
 
 		btrfs_release_path(path);
 		inode = read_one_inode(root, key.offset);
-		if (!inode)
-			return -EIO;
+		if (!inode) {
+			ret = -EIO;
+			break;
+		}
 
 		ret = fixup_inode_link_count(trans, root, inode);
 		iput(inode);
 		if (ret)
-			goto out;
+			break;
 
 		/*
 		 * fixup on a directory may create new entries,
@@ -1589,8 +1592,6 @@ static noinline int fixup_inode_link_cou
 		 */
 		key.offset = (u64)-1;
 	}
-	ret = 0;
-out:
 	btrfs_release_path(path);
 	return ret;
 }


