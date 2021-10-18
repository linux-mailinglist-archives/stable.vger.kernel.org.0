Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8992A431B47
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhJRNcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhJRNaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1022D6136F;
        Mon, 18 Oct 2021 13:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563692;
        bh=2Wp1Zy23ncLg73L2WZLf5Lzwqc7HJa2GFdpduRGAWU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVpoB8mVeJjxkD0y2fFzqxi/kiiAVKf1ZD9M7F/+pecsD6aMDPwur2oytai9lwivm
         v0PGWCE7UoE09uJ7zpZWhK4+gtj9pOD7fkCO12Q6EC4wgD1Mh6yV2c3RmKZAN63xfh
         s6CdtjygRrxy/7m0lC+pkitKX890zUjP3gxGTj5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 07/50] btrfs: deal with errors when replaying dir entry during log replay
Date:   Mon, 18 Oct 2021 15:24:14 +0200
Message-Id: <20211018132326.766656666@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit e15ac6413745e3def00e663de00aea5a717311c1 upstream.

At replay_one_one(), we are treating any error returned from
btrfs_lookup_dir_item() or from btrfs_lookup_dir_index_item() as meaning
that there is no existing directory entry in the fs/subvolume tree.
This is not correct since we can get errors such as, for example, -EIO
when reading extent buffers while searching the fs/subvolume's btree.

So fix that and return the error to the caller when it is not -ENOENT.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1907,7 +1907,14 @@ static noinline int replay_one_name(stru
 		ret = -EINVAL;
 		goto out;
 	}
-	if (IS_ERR_OR_NULL(dst_di)) {
+
+	if (dst_di == ERR_PTR(-ENOENT))
+		dst_di = NULL;
+
+	if (IS_ERR(dst_di)) {
+		ret = PTR_ERR(dst_di);
+		goto out;
+	} else if (!dst_di) {
 		/* we need a sequence number to insert, so we only
 		 * do inserts for the BTRFS_DIR_INDEX_KEY types
 		 */


