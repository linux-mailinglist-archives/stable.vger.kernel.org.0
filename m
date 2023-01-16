Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B911C66CC49
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjAPRYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbjAPRYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:24:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F1B59E63
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:01:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AB6CB8109B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897FFC433F0;
        Mon, 16 Jan 2023 17:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888477;
        bh=73WFUb21fcNqOPg0QvNVM4ryxiOq5tkxg+PEZ8Otv+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftphPUBv9mGWtp+4re+tHt3arFh4qDt3eJoH4OQ1Ynh3TaovRsbZbCKtO7lJXGM0K
         XmQuAGy5vRvv2RdRMYsL/XeqKEcBDF9s+xudR2YDF9W7EHPKhpwEyXxnbAIOK98dzw
         s5/lsR+GF7OABZe5F+yaVabGqa7Iomp+J27cnZ6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14 013/338] udf: Drop unused arguments of udf_delete_aext()
Date:   Mon, 16 Jan 2023 16:48:06 +0100
Message-Id: <20230116154821.309395770@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

commit 6c1e4d06a3808dc67dbce2d631f4c12574567dd5 upstream.

udf_delete_aext() uses its last two arguments only as local variables.
Drop them.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/balloc.c  |    5 ++---
 fs/udf/inode.c   |    8 ++++----
 fs/udf/udfdecl.h |    3 +--
 3 files changed, 7 insertions(+), 9 deletions(-)

--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -531,8 +531,7 @@ static int udf_table_prealloc_blocks(str
 			udf_write_aext(table, &epos, &eloc,
 					(etype << 30) | elen, 1);
 		} else
-			udf_delete_aext(table, epos, eloc,
-					(etype << 30) | elen);
+			udf_delete_aext(table, epos);
 	} else {
 		alloc_count = 0;
 	}
@@ -627,7 +626,7 @@ static int udf_table_new_block(struct su
 	if (goal_elen)
 		udf_write_aext(table, &goal_epos, &goal_eloc, goal_elen, 1);
 	else
-		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
+		udf_delete_aext(table, goal_epos);
 	brelse(goal_epos.bh);
 
 	udf_add_free_space(sb, partition, -1);
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1169,8 +1169,7 @@ static void udf_update_extents(struct in
 
 	if (startnum > endnum) {
 		for (i = 0; i < (startnum - endnum); i++)
-			udf_delete_aext(inode, *epos, laarr[i].extLocation,
-					laarr[i].extLength);
+			udf_delete_aext(inode, *epos);
 	} else if (startnum < endnum) {
 		for (i = 0; i < (endnum - startnum); i++) {
 			udf_insert_aext(inode, *epos, laarr[i].extLocation,
@@ -2202,14 +2201,15 @@ static int8_t udf_insert_aext(struct ino
 	return (nelen >> 30);
 }
 
-int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
-		       struct kernel_lb_addr eloc, uint32_t elen)
+int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
 {
 	struct extent_position oepos;
 	int adsize;
 	int8_t etype;
 	struct allocExtDesc *aed;
 	struct udf_inode_info *iinfo;
+	struct kernel_lb_addr eloc;
+	uint32_t elen;
 
 	if (epos.bh) {
 		get_bh(epos.bh);
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -161,8 +161,7 @@ extern int udf_add_aext(struct inode *,
 			struct kernel_lb_addr *, uint32_t, int);
 extern void udf_write_aext(struct inode *, struct extent_position *,
 			   struct kernel_lb_addr *, uint32_t, int);
-extern int8_t udf_delete_aext(struct inode *, struct extent_position,
-			      struct kernel_lb_addr, uint32_t);
+extern int8_t udf_delete_aext(struct inode *, struct extent_position);
 extern int8_t udf_next_aext(struct inode *, struct extent_position *,
 			    struct kernel_lb_addr *, uint32_t *, int);
 extern int8_t udf_current_aext(struct inode *, struct extent_position *,


