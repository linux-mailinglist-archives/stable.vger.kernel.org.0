Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E3C608A73
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiJVIzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbiJVIyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:54:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3292F5844;
        Sat, 22 Oct 2022 01:13:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45B85B82E49;
        Sat, 22 Oct 2022 08:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746A5C433D6;
        Sat, 22 Oct 2022 08:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426093;
        bh=crSfYZdlpZpIdRFdSPKQ20saC6ktN5bPHpKGg0bi5tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=We9RWXtKsE3dYEfDC8eVI7zTjixvCPN9zdbCvWIjqeuIqC2mUEfkTLdQAq5AQaSPv
         plFxdkV0hi9iY4+GMMn+AxegOLSfI7cLHWTraTsdok+yDUVkXlU2PauFxw28A6NQR2
         6blr8OUAFuAFPnJJ3QgAwXqqgeV7/Ux90BcQOSu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.19 715/717] drm/i915: Rename block_size()/block_offset()
Date:   Sat, 22 Oct 2022 09:29:54 +0200
Message-Id: <20221022072530.098549125@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 39b1bc4b5bcccac781267bb826b035fbb99c8b9d upstream.

Give block_size()/block_offset() a "raw_" prefix since they
both operate on the "raw" (as in not duplicated) BDB block
contents.

What actually spurred this was a conflict between intel_bios.c
block_size() vs. block_size() from blkdev.h. That only
happened to me on a custom tree where we somehow manage to
include blkdev.h into intel_bios.c. But I think the rename
makes sense anyway to clarify the purpose of these functions.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220519140010.10600-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -123,7 +123,7 @@ find_raw_section(const void *_bdb, enum
  * Offset from the start of BDB to the start of the
  * block data (just past the block header).
  */
-static u32 block_offset(const void *bdb, enum bdb_block_id section_id)
+static u32 raw_block_offset(const void *bdb, enum bdb_block_id section_id)
 {
 	const void *block;
 
@@ -135,7 +135,7 @@ static u32 block_offset(const void *bdb,
 }
 
 /* size of the block excluding the header */
-static u32 block_size(const void *bdb, enum bdb_block_id section_id)
+static u32 raw_block_size(const void *bdb, enum bdb_block_id section_id)
 {
 	const void *block;
 
@@ -232,7 +232,7 @@ static bool validate_lfp_data_ptrs(const
 	int data_block_size, lfp_data_size;
 	int i;
 
-	data_block_size = block_size(bdb, BDB_LVDS_LFP_DATA);
+	data_block_size = raw_block_size(bdb, BDB_LVDS_LFP_DATA);
 	if (data_block_size == 0)
 		return false;
 
@@ -309,7 +309,7 @@ static bool fixup_lfp_data_ptrs(const vo
 	u32 offset;
 	int i;
 
-	offset = block_offset(bdb, BDB_LVDS_LFP_DATA);
+	offset = raw_block_offset(bdb, BDB_LVDS_LFP_DATA);
 
 	for (i = 0; i < 16; i++) {
 		if (ptrs->ptr[i].fp_timing.offset < offset ||


