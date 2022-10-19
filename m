Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE6603B0F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJSIB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJSIBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:01:55 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A079A76;
        Wed, 19 Oct 2022 01:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666166514; x=1697702514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p61VJo4/RmRvFktHyRNnR84pC2LY7KGpn+6dqLA1Pyo=;
  b=H9HgRk17VRlgu1LNaQpcz3kA65hgHFeihx2xUIeT7Lp95YIfK0JfUVz3
   b5BGHVdcm0QhG0RF+GduS+kab7qF4zN9s5OjGFxxYQHatV17VghxFaZlK
   Ip+zmBuiS/h4OQYcyQPzQKPgc/LiLfmGTZfGEYyZUwE/WI74rDioPEhAd
   7g9KYPyVuB+S/HF8Q+auVgsnCUx0EF87XpAG5JLWqe5EcjO0rk0qk1wKt
   LTSqCo0X8KBZvOt92AQZv9X12+oij4vxVy1bf2FNAq8WkID4Dvzhm2o6F
   frXvAPDCkiT1H2nPTRiGIb6zSyvh5xgkFjZtHt+9wlKIRZzrCaKk2W7kw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="307446736"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="307446736"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 01:01:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="629133400"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="629133400"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga002.jf.intel.com with SMTP; 19 Oct 2022 01:01:50 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 19 Oct 2022 11:01:49 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH stable-5.19+ 1/2] drm/i915/bios: Validate fp_timing terminator presence
Date:   Wed, 19 Oct 2022 11:01:48 +0300
Message-Id: <20221019080149.22870-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <Y0+fex0i0vmBL6QX@kroah.com>
References: <Y0+fex0i0vmBL6QX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Validate the LFP data block a bit hardwer by making sure the
fp_timing terminators (0xffff) are where we expect them to be.

Cc: <stable@vger.kernel.org> # 5.19.x: 39b1bc4b5bcc: drm/i915: Rename block_size()/block_offset()
Cc: <stable@vger.kernel.org> # 5.19+
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220818192223.29881-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 4e78d6023c15c6acce8fbe42e13027c460395522)
---
 drivers/gpu/drm/i915/display/intel_bios.c | 60 ++++++++++++-----------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 7d6eb9ad7a02..1a30e645c5a7 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -135,18 +135,6 @@ static u32 raw_block_offset(const void *bdb, enum bdb_block_id section_id)
 	return block - bdb;
 }
 
-/* size of the block excluding the header */
-static u32 raw_block_size(const void *bdb, enum bdb_block_id section_id)
-{
-	const void *block;
-
-	block = find_raw_section(bdb, section_id);
-	if (!block)
-		return 0;
-
-	return get_blocksize(block);
-}
-
 struct bdb_block_entry {
 	struct list_head node;
 	enum bdb_block_id section_id;
@@ -231,9 +219,14 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 {
 	int fp_timing_size, dvo_timing_size, panel_pnp_id_size, panel_name_size;
 	int data_block_size, lfp_data_size;
+	const void *data_block;
 	int i;
 
-	data_block_size = raw_block_size(bdb, BDB_LVDS_LFP_DATA);
+	data_block = find_raw_section(bdb, BDB_LVDS_LFP_DATA);
+	if (!data_block)
+		return false;
+
+	data_block_size = get_blocksize(data_block);
 	if (data_block_size == 0)
 		return false;
 
@@ -261,21 +254,6 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 	if (16 * lfp_data_size > data_block_size)
 		return false;
 
-	/*
-	 * Except for vlv/chv machines all real VBTs seem to have 6
-	 * unaccounted bytes in the fp_timing table. And it doesn't
-	 * appear to be a really intentional hole as the fp_timing
-	 * 0xffff terminator is always within those 6 missing bytes.
-	 */
-	if (fp_timing_size + dvo_timing_size + panel_pnp_id_size != lfp_data_size &&
-	    fp_timing_size + 6 + dvo_timing_size + panel_pnp_id_size != lfp_data_size)
-		return false;
-
-	if (ptrs->ptr[0].fp_timing.offset + fp_timing_size > ptrs->ptr[0].dvo_timing.offset ||
-	    ptrs->ptr[0].dvo_timing.offset + dvo_timing_size != ptrs->ptr[0].panel_pnp_id.offset ||
-	    ptrs->ptr[0].panel_pnp_id.offset + panel_pnp_id_size != lfp_data_size)
-		return false;
-
 	/* make sure the table entries have uniform size */
 	for (i = 1; i < 16; i++) {
 		if (ptrs->ptr[i].fp_timing.table_size != fp_timing_size ||
@@ -289,6 +267,23 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 			return false;
 	}
 
+	/*
+	 * Except for vlv/chv machines all real VBTs seem to have 6
+	 * unaccounted bytes in the fp_timing table. And it doesn't
+	 * appear to be a really intentional hole as the fp_timing
+	 * 0xffff terminator is always within those 6 missing bytes.
+	 */
+	if (fp_timing_size + 6 + dvo_timing_size + panel_pnp_id_size == lfp_data_size)
+		fp_timing_size += 6;
+
+	if (fp_timing_size + dvo_timing_size + panel_pnp_id_size != lfp_data_size)
+		return false;
+
+	if (ptrs->ptr[0].fp_timing.offset + fp_timing_size != ptrs->ptr[0].dvo_timing.offset ||
+	    ptrs->ptr[0].dvo_timing.offset + dvo_timing_size != ptrs->ptr[0].panel_pnp_id.offset ||
+	    ptrs->ptr[0].panel_pnp_id.offset + panel_pnp_id_size != lfp_data_size)
+		return false;
+
 	/* make sure the tables fit inside the data block */
 	for (i = 0; i < 16; i++) {
 		if (ptrs->ptr[i].fp_timing.offset + fp_timing_size > data_block_size ||
@@ -300,6 +295,15 @@ static bool validate_lfp_data_ptrs(const void *bdb,
 	if (ptrs->panel_name.offset + 16 * panel_name_size > data_block_size)
 		return false;
 
+	/* make sure fp_timing terminators are present at expected locations */
+	for (i = 0; i < 16; i++) {
+		const u16 *t = data_block + ptrs->ptr[i].fp_timing.offset +
+			fp_timing_size - 2;
+
+		if (*t != 0xffff)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.35.1

