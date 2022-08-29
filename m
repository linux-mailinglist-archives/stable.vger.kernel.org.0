Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B627A5A4EB0
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiH2N6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiH2N6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:58:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E86B7E004
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661781517; x=1693317517;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=foAXf8sIUIu096dssSvjV0luk4lPIOMWX/ySGa35avo=;
  b=lte5ZlC++bhyJ+gbUrXRj3meuvtsjglFTRUXhNLh5lM93bq8HaynI4fr
   r7CDRWx9Ghq/O2puczGJaP3ZmOwgKpT45IC25Y5wRi7KOmVd/ZgSvuDkz
   XUS5FgeQ6pnCgZbfhIswnTaV336k2hP16tV039eZO46BxhaLn/IqhlMXT
   7ZcBWmebWcjifwL+qAD4zjCl4LlGKC7IGW6S9+A9Unn+b322Rz6BZjC9G
   g907awpCDEG2r0X7etA45/4Z4MZh1bczQEb5L5SYOVBdaUc4m90MgcCoq
   Quuc96qtcQl0afxaBbBcGa4XiNEQJqIpbSPWCHs7gMgrXG+ER35Ikd+jD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="274647894"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="274647894"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 06:58:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="672388235"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga008.fm.intel.com with SMTP; 29 Aug 2022 06:58:34 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 29 Aug 2022 16:58:34 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/bios: Copy the whole MIPI sequence block
Date:   Mon, 29 Aug 2022 16:58:34 +0300
Message-Id: <20220829135834.8585-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Turns out the MIPI sequence block version number and
new block size fields are considered part of the block
header and are not included in the reported new block size
field itself. Bump up the block size appropriately so that
we'll copy over the last five bytes of the block as well.

For this particular machine those last five bytes included
parts of the GPIO op for the backlight on sequence, causing
the backlight no longer to turn back on:

 		Sequence 6 - MIPI_SEQ_BACKLIGHT_ON
 			Delay: 20000 us
-			GPIO index 0, number 0, set 0 (0x00)
+			GPIO index 1, number 70, set 1 (0x01)

Cc: stable@vger.kernel.org
Fixes: e163cfb4c96d ("drm/i915/bios: Make copies of VBT data blocks")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6652
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_bios.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 81d6cfbd2615..d493d04f4049 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -479,6 +479,13 @@ init_bdb_block(struct drm_i915_private *i915,
 
 	block_size = get_blocksize(block);
 
+	/*
+	 * Version number and new block size are considered
+	 * part of the header for MIPI sequenece block v3+.
+	 */
+	if (section_id == BDB_MIPI_SEQUENCE && *(const u8 *)block >= 3)
+		block_size += 5;
+
 	entry = kzalloc(struct_size(entry, data, max(min_size, block_size) + 3),
 			GFP_KERNEL);
 	if (!entry) {
-- 
2.35.1

