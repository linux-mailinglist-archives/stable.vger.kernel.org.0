Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4E84BDC56
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbiBUJGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:06:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347026AbiBUJEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:04:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B05F2DD6A;
        Mon, 21 Feb 2022 00:58:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC1D3B80EC0;
        Mon, 21 Feb 2022 08:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3392C340E9;
        Mon, 21 Feb 2022 08:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433921;
        bh=/qkCfwpbbo+NcTqTpe8lchEZWjXUEYoPs8CNx3cbU3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxNrjbUV+uVav7QK5kCaSu4/Y0wujxtXGg2QoDRP/cR6DfQeTJiGpDeXEInyGCt0F
         sAA0oWjxlg9QUehJCn6mGPNVbt5nqyu+zHELe0UARLlsMqb42kjKEM01N+iKlngURb
         wDUD+0wYNOSPVbq8y35BcQqCtwyXQd0z2mcs/rF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.4 31/80] ext4: prevent partial update of the extent blocks
Date:   Mon, 21 Feb 2022 09:49:11 +0100
Message-Id: <20220221084916.598342313@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -133,14 +133,25 @@ static int ext4_ext_truncate_extend_rest
 static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path)
 {
+	int err = 0;
+
 	if (path->p_bh) {
 		/* path points to block */
 		BUFFER_TRACE(path->p_bh, "get_write_access");
-		return ext4_journal_get_write_access(handle, path->p_bh);
+		err = ext4_journal_get_write_access(handle, path->p_bh);
+
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
@@ -160,6 +171,9 @@ int __ext4_ext_dirty(const char *where,
 		/* path points to block */
 		err = __ext4_handle_dirty_metadata(where, line, handle,
 						   inode, path->p_bh);
+		/* Extents updating done, re-set verified flag */
+		if (!err)
+			set_buffer_verified(path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
 		err = ext4_mark_inode_dirty(handle, inode);


