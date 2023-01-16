Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F151466C63B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjAPQQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbjAPQQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:16:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7532D14C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A04ACB81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D3FC433F0;
        Mon, 16 Jan 2023 16:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885372;
        bh=hky+L9OqszPzzfyyNFRtDqP5ZOd/0ysZcJ2HNj/l+b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uklBN41bHP1/nYbZXgWz8YyQSPfNRrmtY8y9G3vghmJvX5jvL77fHI3tWA6hwy2Uy
         htJ7RKK7wXowEncazZMzZ3Xbq5XLpPohoHzqhAKjjZAawwVcwG3EhF6rJhgCZNNuiD
         lAO3MjKeGZqLAMl+dUjKyU6dHdQ56QeCZpC3rRw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 003/658] udf: Fix preallocation discarding at indirect extent boundary
Date:   Mon, 16 Jan 2023 16:41:31 +0100
Message-Id: <20230116154909.820623910@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit cfe4c1b25dd6d2f056afc00b7c98bcb3dd0b1fc3 upstream.

When preallocation extent is the first one in the extent block, the
code would corrupt extent tree header instead. Fix the problem and use
udf_delete_aext() for deleting extent to avoid some code duplication.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/truncate.c |   45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -120,60 +120,41 @@ void udf_truncate_tail_extent(struct ino
 
 void udf_discard_prealloc(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
+	struct extent_position prev_epos = {};
 	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
-	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
 	    inode->i_size == iinfo->i_lenExtents)
 		return;
 
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(struct short_ad);
-	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(struct long_ad);
-	else
-		adsize = 0;
-
 	epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
-		etype = netype;
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+		brelse(prev_epos.bh);
+		prev_epos = epos;
+		if (prev_epos.bh)
+			get_bh(prev_epos.bh);
+
+		etype = udf_next_aext(inode, &epos, &eloc, &elen, 1);
 		lbcount += elen;
 	}
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-		epos.offset -= adsize;
 		lbcount -= elen;
-		extent_trunc(inode, &epos, &eloc, etype, elen, 0);
-		if (!epos.bh) {
-			iinfo->i_lenAlloc =
-				epos.offset -
-				udf_file_entry_alloc_offset(inode);
-			mark_inode_dirty(inode);
-		} else {
-			struct allocExtDesc *aed =
-				(struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs =
-				cpu_to_le32(epos.offset -
-					    sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-				udf_update_tag(epos.bh->b_data, epos.offset);
-			else
-				udf_update_tag(epos.bh->b_data,
-					       sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(epos.bh, inode);
-		}
+		udf_delete_aext(inode, prev_epos);
+		udf_free_blocks(inode->i_sb, inode, &eloc, 0,
+				DIV_ROUND_UP(elen, 1 << inode->i_blkbits));
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
 	iinfo->i_lenExtents = lbcount;
 	brelse(epos.bh);
+	brelse(prev_epos.bh);
 }
 
 static void udf_update_alloc_ext_desc(struct inode *inode,


