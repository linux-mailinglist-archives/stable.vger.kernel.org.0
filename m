Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20BF3A03C1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhFHTVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237818AbhFHTR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:17:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97CAD6196E;
        Tue,  8 Jun 2021 18:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178285;
        bh=TqcsrtaAK3mydm3PgvRjUq5nISAp3b9Bw3fSEh4ivOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMDwE3hYXRs9XQAJlJ6sbpQW7ZPY58LFjPmg1AR2LcwIcZc8Gu3HKRFtVA11BepD3
         dDXJ+Os5V3/vn+GNc6dpXUWBRUWqT7UGnPQnfDFFyuOujyuqwptPi7MtTtmWmgTDq8
         SNZa9Y+OMWqCcfrxxTnC5oj4fVCnQFo/9PIiLQmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 145/161] btrfs: fixup error handling in fixup_inode_link_counts
Date:   Tue,  8 Jun 2021 20:27:55 +0200
Message-Id: <20210608175950.351235095@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
@@ -1791,6 +1791,7 @@ static noinline int fixup_inode_link_cou
 			break;
 
 		if (ret == 1) {
+			ret = 0;
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
@@ -1803,17 +1804,19 @@ static noinline int fixup_inode_link_cou
 
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
@@ -1822,8 +1825,6 @@ static noinline int fixup_inode_link_cou
 		 */
 		key.offset = (u64)-1;
 	}
-	ret = 0;
-out:
 	btrfs_release_path(path);
 	return ret;
 }


