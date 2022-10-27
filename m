Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E45660FDB0
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiJ0Q6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbiJ0Q56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA7D17C55F
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96E62B826F9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FE2C433C1;
        Thu, 27 Oct 2022 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889875;
        bh=TIXm8p8DgPNTH8m3W0pN72PGug2Z8vmdMXAgdrnwf0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMRvCLpA2TBRk+y2D0G6kpN5j9ihgWPbYCDw1TqdneY+dSKK3sL172aUOAYiJNs9v
         wRqMAkon0gQABXqHF2Kx29j34EwlmIA3OcUmSvsvTmD0qgtfDbE3f/45NztgheeXvR
         /KGImvODLKk2nV4WVarLv+fv+QTEBZ99Mxd8eYy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.0 24/94] media: venus: Fix NV12 decoder buffer discovery on HFI_VERSION_1XX
Date:   Thu, 27 Oct 2022 18:54:26 +0200
Message-Id: <20221027165058.037396824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 7f77fa9f378c528edb38dbf23ff1273c81429d49 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/helpers.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -1800,7 +1800,7 @@ bool venus_helper_check_format(struct ve
 	struct venus_core *core = inst->core;
 	u32 fmt = to_hfi_raw_fmt(v4l2_pixfmt);
 	struct hfi_plat_caps *caps;
-	u32 buftype;
+	bool found;
 
 	if (!fmt)
 		return false;
@@ -1809,12 +1809,13 @@ bool venus_helper_check_format(struct ve
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
 


