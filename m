Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DAA47FFE5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbhL0Plk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:40 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42254 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239768AbhL0Pkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBBF4CE10B3;
        Mon, 27 Dec 2021 15:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966CDC36AE7;
        Mon, 27 Dec 2021 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619628;
        bh=U3zLV2tJxA7+W5P5/lmqJMBTA8EpQQ+PNB/Ddo192cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WREJIorW8w7muNxaR0QrOwpxN+kYtPonIiXy5zwU3YmyuRrAw/WGTvwbvGHOdN5cX
         HY7gxDAlC7FbyuBbyRMhDUDzrdKhz/GI4cXfwhR1X4DIHnVVImJPqNVTYEk4P/lvlj
         iONRPsgc/GLzGmAqd5dVgyTVDSMn++xQcuu0WW3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 003/128] ext4: prevent partial update of the extent blocks
Date:   Mon, 27 Dec 2021 16:29:38 +0100
Message-Id: <20211227151331.622103717@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 0f2f87d51aebcf71a709b52f661d681594c7dffa upstream.

In the most error path of current extents updating operations are not
roll back partial updates properly when some bad things happens(.e.g in
ext4_ext_insert_extent()). So we may get an inconsistent extents tree
if journal has been aborted due to IO error, which may probability lead
to BUGON later when we accessing these extent entries in errors=continue
mode. This patch drop extent buffer's verify flag before updatng the
contents in ext4_ext_get_access(), and reset it after updating in
__ext4_ext_dirty(). After this patch we could force to check the extent
buffer if extents tree updating was break off, make sure the extents are
consistent.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210908120850.4012324-4-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -136,15 +136,25 @@ int ext4_datasem_ensure_credits(handle_t
 static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path)
 {
+	int err = 0;
+
 	if (path->p_bh) {
 		/* path points to block */
 		BUFFER_TRACE(path->p_bh, "get_write_access");
-		return ext4_journal_get_write_access(handle, inode->i_sb,
-						     path->p_bh, EXT4_JTR_NONE);
+		err = ext4_journal_get_write_access(handle, inode->i_sb,
+						    path->p_bh, EXT4_JTR_NONE);
+		/*
+		 * The extent buffer's verified bit will be set again in
+		 * __ext4_ext_dirty(). We could leave an inconsistent
+		 * buffer if the extents updating procudure break off du
+		 * to some error happens, force to check it again.
+		 */
+		if (!err)
+			clear_buffer_verified(path->p_bh);
 	}
 	/* path points to leaf/index in inode body */
 	/* we use in-core data, no need to protect them */
-	return 0;
+	return err;
 }
 
 /*
@@ -165,6 +175,9 @@ static int __ext4_ext_dirty(const char *
 		/* path points to block */
 		err = __ext4_handle_dirty_metadata(where, line, handle,
 						   inode, path->p_bh);
+		/* Extents updating done, re-set verified flag */
+		if (!err)
+			set_buffer_verified(path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
 		err = ext4_mark_inode_dirty(handle, inode);


