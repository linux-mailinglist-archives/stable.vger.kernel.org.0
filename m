Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF760E43D
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiJZPLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiJZPLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:11:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C843DEF27
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21023B82033
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F95C433D6;
        Wed, 26 Oct 2022 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666797087;
        bh=DZsatlmOLULpxYs4WVSLiB21T2XrA57KuRSW2rvGA7c=;
        h=Subject:To:Cc:From:Date:From;
        b=qzmTeliacUmt7Od49bxas1nPcXOVD98HnRFNPhdGebL8H4G2V/q3XMLdCcqR05M5i
         AMbcmw1fWcxcNNLPINPNaEmMOK4TNVGrfKlcXVQV8F8SzJ6bfZZuXttXn2EXlbCIDg
         EQi2iY9K597AEdrFUpQjN77An7enY5RFIv3Rio84=
Subject: FAILED: patch "[PATCH] media: venus: dec: Handle the case where find_format fails" failed to apply to 4.14-stable tree
To:     bryan.odonoghue@linaro.org, mchehab@kernel.org,
        stanimir.varbanov@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:11:25 +0200
Message-ID: <1666797085178224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

06a2da340f76 ("media: venus: dec: Handle the case where find_format fails")
1946117b8f13 ("media: venus: keep resolution when adjusting format")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 06a2da340f762addc5935bf851d95b14d4692db2 Mon Sep 17 00:00:00 2001
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Date: Tue, 26 Jul 2022 04:14:54 +0200
Subject: [PATCH] media: venus: dec: Handle the case where find_format fails

Debugging the decoder on msm8916 I noticed the vdec probe was crashing if
the fmt pointer was NULL.

A similar fix from Colin Ian King found by Coverity was implemented for the
encoder. Implement the same fix on the decoder.

Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Cc: stable@vger.kernel.org  # v4.13+
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index ac0bb45d07f4..4ceaba37e2e5 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -183,6 +183,8 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),

