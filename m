Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FB063DE06
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiK3SdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiK3SdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A0F25E9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F01561AFE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F190C433D7;
        Wed, 30 Nov 2022 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833175;
        bh=EiVUydKqMlmhWZB3pUXbF6iKdIGZljJ9E4OID+VBjcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bud1pChIA1p3jhO5miw0KRwf7qsBbMcnWY41E0lR8146mLxAbwLZ+zqedNGC3b7Wp
         4mdKh2dQrFYWBMDOu3xhMLslgOp9OwQm5JX62f5P6I25flgcPwj9JCaCYoYuqdlF9S
         i3y0veogV2b4K37Jo+VAuvuDVJ1UPUkaEKdBJrQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>,
        Rafael Gieschke <rafael.gieschke@rz.uni-freiburg.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/206] drm/display: Dont assume dual mode adaptors support i2c sub-addressing
Date:   Wed, 30 Nov 2022 19:21:06 +0100
Message-Id: <20221130180533.359483578@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>

[ Upstream commit 5954acbacbd1946b96ce8ee799d309cb0cd3cb9d ]

Current dual mode adaptor ("DP++") detection code assumes that all
adaptors support i2c sub-addressing for read operations from the
DP-HDMI adaptor ID buffer.  It has been observed that multiple
adaptors do not in fact support this, and always return data starting
at register 0.  On affected adaptors, the code fails to read the proper
registers that would identify the device as a type 2 adaptor, and
handles those as type 1, limiting the TMDS clock to 165MHz, even if
the according register would announce a higher TMDS clock.
Fix this by always reading the ID buffer starting from offset 0, and
discarding any bytes before the actual offset of interest.

We tried finding authoritative documentation on whether or not this is
allowed behaviour, but since all the official VESA docs are paywalled,
the best we could come up with was the spec sheet for Texas Instruments'
SNx5DP149 chip family.[1]  It explicitly mentions that sub-addressing is
supported for register writes, but *not* for reads (See NOTE in
section 8.5.3).  Unless TI openly decided to violate the VESA spec, one
could take that as a hint that sub-addressing is in fact not mandated
by VESA.
The other two adaptors affected used the PS8409(A) and the LT8611,
according to the data returned from their ID buffers.

[1] https://www.ti.com/lit/ds/symlink/sn75dp149.pdf

Cc: stable@vger.kernel.org
Signed-off-by: Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>
Reviewed-by: Rafael Gieschke <rafael.gieschke@rz.uni-freiburg.de>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006113314.41101987@computer
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_dual_mode_helper.c | 51 +++++++++++++----------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_dual_mode_helper.c b/drivers/gpu/drm/drm_dp_dual_mode_helper.c
index 9faf49354cab..cb52a00ae1b1 100644
--- a/drivers/gpu/drm/drm_dp_dual_mode_helper.c
+++ b/drivers/gpu/drm/drm_dp_dual_mode_helper.c
@@ -63,23 +63,45 @@
 ssize_t drm_dp_dual_mode_read(struct i2c_adapter *adapter,
 			      u8 offset, void *buffer, size_t size)
 {
+	u8 zero = 0;
+	char *tmpbuf = NULL;
+	/*
+	 * As sub-addressing is not supported by all adaptors,
+	 * always explicitly read from the start and discard
+	 * any bytes that come before the requested offset.
+	 * This way, no matter whether the adaptor supports it
+	 * or not, we'll end up reading the proper data.
+	 */
 	struct i2c_msg msgs[] = {
 		{
 			.addr = DP_DUAL_MODE_SLAVE_ADDRESS,
 			.flags = 0,
 			.len = 1,
-			.buf = &offset,
+			.buf = &zero,
 		},
 		{
 			.addr = DP_DUAL_MODE_SLAVE_ADDRESS,
 			.flags = I2C_M_RD,
-			.len = size,
+			.len = size + offset,
 			.buf = buffer,
 		},
 	};
 	int ret;
 
+	if (offset) {
+		tmpbuf = kmalloc(size + offset, GFP_KERNEL);
+		if (!tmpbuf)
+			return -ENOMEM;
+
+		msgs[1].buf = tmpbuf;
+	}
+
 	ret = i2c_transfer(adapter, msgs, ARRAY_SIZE(msgs));
+	if (tmpbuf)
+		memcpy(buffer, tmpbuf + offset, size);
+
+	kfree(tmpbuf);
+
 	if (ret < 0)
 		return ret;
 	if (ret != ARRAY_SIZE(msgs))
@@ -208,18 +230,6 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(const struct drm_device *dev,
 	if (ret)
 		return DRM_DP_DUAL_MODE_UNKNOWN;
 
-	/*
-	 * Sigh. Some (maybe all?) type 1 adaptors are broken and ack
-	 * the offset but ignore it, and instead they just always return
-	 * data from the start of the HDMI ID buffer. So for a broken
-	 * type 1 HDMI adaptor a single byte read will always give us
-	 * 0x44, and for a type 1 DVI adaptor it should give 0x00
-	 * (assuming it implements any registers). Fortunately neither
-	 * of those values will match the type 2 signature of the
-	 * DP_DUAL_MODE_ADAPTOR_ID register so we can proceed with
-	 * the type 2 adaptor detection safely even in the presence
-	 * of broken type 1 adaptors.
-	 */
 	ret = drm_dp_dual_mode_read(adapter, DP_DUAL_MODE_ADAPTOR_ID,
 				    &adaptor_id, sizeof(adaptor_id));
 	drm_dbg_kms(dev, "DP dual mode adaptor ID: %02x (err %zd)\n", adaptor_id, ret);
@@ -233,11 +243,10 @@ enum drm_dp_dual_mode_type drm_dp_dual_mode_detect(const struct drm_device *dev,
 				return DRM_DP_DUAL_MODE_TYPE2_DVI;
 		}
 		/*
-		 * If neither a proper type 1 ID nor a broken type 1 adaptor
-		 * as described above, assume type 1, but let the user know
-		 * that we may have misdetected the type.
+		 * If not a proper type 1 ID, still assume type 1, but let
+		 * the user know that we may have misdetected the type.
 		 */
-		if (!is_type1_adaptor(adaptor_id) && adaptor_id != hdmi_id[0])
+		if (!is_type1_adaptor(adaptor_id))
 			drm_err(dev, "Unexpected DP dual mode adaptor ID %02x\n", adaptor_id);
 
 	}
@@ -343,10 +352,8 @@ EXPORT_SYMBOL(drm_dp_dual_mode_get_tmds_output);
  * @enable: enable (as opposed to disable) the TMDS output buffers
  *
  * Set the state of the TMDS output buffers in the adaptor. For
- * type2 this is set via the DP_DUAL_MODE_TMDS_OEN register. As
- * some type 1 adaptors have problems with registers (see comments
- * in drm_dp_dual_mode_detect()) we avoid touching the register,
- * making this function a no-op on type 1 adaptors.
+ * type2 this is set via the DP_DUAL_MODE_TMDS_OEN register.
+ * Type1 adaptors do not support any register writes.
  *
  * Returns:
  * 0 on success, negative error code on failure
-- 
2.35.1



