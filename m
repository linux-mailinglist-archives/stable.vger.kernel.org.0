Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9659A5E8AB4
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 11:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiIXJXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 05:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiIXJXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 05:23:17 -0400
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024A513943C
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 02:23:16 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1oc1NT-009XeD-Ft; Sat, 24 Sep 2022 09:23:15 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sat, 24 Sep 2022 09:21:43 +0000
Subject: [git:media_stage/master] media: venus: Fix NV12 decoder buffer discovery on HFI_VERSION_1XX
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1oc1NT-009XeD-Ft@www.linuxtv.org>
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: Fix NV12 decoder buffer discovery on HFI_VERSION_1XX
Author:  Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Date:    Tue Jul 26 04:14:55 2022 +0200

HFI_VERSION_1XX uses HFI_BUFFER_OUTPUT not HFI_BUFFER_OUTPUT2 for decoder
buffers.

venus_helper_check_format() places a constraint on an output buffer to be
of type HFI_BUFFER_OUTPUT2. HFI_1XX uses HFI_BUFFER_OUTPUT though.

Switching to the logic used in venus_helper_get_out_fmts() first checking
for HFI_BUFFER_OUTPUT and then HFI_BUFFER_OUTPUT2 resolves on HFI_1XX.

db410c before:
root@linaro-alip:~# v4l2-ctl  -d /dev/video0 --list-formats
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture Multiplanar

        [0]: 'MPG4' (MPEG-4 Part 2 ES, compressed)
        [1]: 'H263' (H.263, compressed)
        [2]: 'H264' (H.264, compressed)
        [3]: 'VP80' (VP8, compressed)

root@linaro-alip:~# v4l2-ctl  -d /dev/video1 --list-formats
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture Multiplanar

db410c after:
root@linaro-alip:~# v4l2-ctl  -d /dev/video0 --list-formats
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture Multiplanar

        [0]: 'MPG4' (MPEG-4 Part 2 ES, compressed)
        [1]: 'H263' (H.263, compressed)
        [2]: 'H264' (H.264, compressed)
        [3]: 'VP80' (VP8, compressed)

root@linaro-alip:~# v4l2-ctl  -d /dev/video1 --list-formats
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture Multiplanar

        [0]: 'NV12' (Y/CbCr 4:2:0)

Validated playback with ffplay on db410c with h264 and vp8 decoding.

Fixes: 9593126dae3e ("media: venus: Add a handling of QC08C compressed format")
Cc: stable@vger.kernel.org  # v5.19
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/qcom/venus/helpers.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 60de4200375d..ab6a29ffc81e 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -1800,7 +1800,7 @@ bool venus_helper_check_format(struct venus_inst *inst, u32 v4l2_pixfmt)
 	struct venus_core *core = inst->core;
 	u32 fmt = to_hfi_raw_fmt(v4l2_pixfmt);
 	struct hfi_plat_caps *caps;
-	u32 buftype;
+	bool found;
 
 	if (!fmt)
 		return false;
@@ -1809,12 +1809,13 @@ bool venus_helper_check_format(struct venus_inst *inst, u32 v4l2_pixfmt)
 	if (!caps)
 		return false;
 
-	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
-		buftype = HFI_BUFFER_OUTPUT2;
-	else
-		buftype = HFI_BUFFER_OUTPUT;
+	found = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT, fmt);
+	if (found)
+		goto done;
 
-	return find_fmt_from_caps(caps, buftype, fmt);
+	found = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT2, fmt);
+done:
+	return found;
 }
 EXPORT_SYMBOL_GPL(venus_helper_check_format);
 
