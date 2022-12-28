Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91309657D00
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiL1PiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiL1PiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:38:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303BD164B9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFC5561542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D461AC433D2;
        Wed, 28 Dec 2022 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241897;
        bh=vRLkE86fpirHqul2CUIg/o2NFoI2q2mrfmZebt6V5PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faxhM2sDYq04aOY7LNqhE2VpYDfY2vDumeFO07sTTMDptUa1yIi3lBz8eNpp4od0b
         Es12nq4ITmrHugWOnktvBLPyB8hFC7YudMBc6yNG7dRCeQw0AV8t7T46TojG+jUnBm
         jckbpCplP+tnRc5p6cslXV43StBGjH1aQnoDlP20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0341/1073] media: amphion: add lock around vdec_g_fmt
Date:   Wed, 28 Dec 2022 15:32:09 +0100
Message-Id: <20221228144337.268656126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 8480dd5fb3c82b5887d456b3fbe4201d99231814 ]

the capture format may be changed when
sequence header is parsed,
it may be read and write in the same time,
add lock around vdec_g_fmt to synchronize it

Fixes: 6de8d628df6e ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index 84c90ce265f2..b27e6bed85f0 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -286,6 +286,7 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	struct vpu_format *cur_fmt;
 	int i;
 
+	vpu_inst_lock(inst);
 	cur_fmt = vpu_get_format(inst, f->type);
 
 	pixmp->pixelformat = cur_fmt->pixfmt;
@@ -303,6 +304,7 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	f->fmt.pix_mp.xfer_func = vdec->codec_info.transfer_chars;
 	f->fmt.pix_mp.ycbcr_enc = vdec->codec_info.matrix_coeffs;
 	f->fmt.pix_mp.quantization = vdec->codec_info.full_range;
+	vpu_inst_unlock(inst);
 
 	return 0;
 }
-- 
2.35.1



