Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966B35B6F90
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiIMONz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiIMONW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:13:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBCD5FF57;
        Tue, 13 Sep 2022 07:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E842B80F00;
        Tue, 13 Sep 2022 14:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEB3C433D6;
        Tue, 13 Sep 2022 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078212;
        bh=WFPxjJ3eyAm8L+DfVYrI91L8V/mwV4VTHN3iIzxFqtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TteNBQSa/HtoleHoAqseEcR9bvP0P/hP+qjR9AhkTRAcsZhKjlE9+PIG8DdJjk6w4
         M9Q1gHLw0nJPOSsDy8sflWiNukk+PMPSLHmOcWOI1rcALdweXoPT5QGb+sDKroK5b8
         8KXnRChv8FZjNhUeBYWc1zz3nnN6W5eKktxqYpnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 055/192] drm/i915/bios: Copy the whole MIPI sequence block
Date:   Tue, 13 Sep 2022 16:02:41 +0200
Message-Id: <20220913140412.679956915@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit edca5a2c373db61efa959307c13ed9156b1c14d9 upstream.

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
Link: https://patchwork.freedesktop.org/patch/msgid/20220829135834.8585-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a06289f3f72431f3777af95ea1226b5b0abdc426)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -478,6 +478,13 @@ init_bdb_block(struct drm_i915_private *
 
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


