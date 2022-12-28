Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871E8657D9D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiL1PpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbiL1PpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755B617599
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15EF8B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D61C433D2;
        Wed, 28 Dec 2022 15:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242301;
        bh=vRLkE86fpirHqul2CUIg/o2NFoI2q2mrfmZebt6V5PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7bXHWWqUbVLlrlMwMJVwhKiUj+oEEotG54caWtIuNwj1gaW+0P9t/I0Xl4MwUp0D
         Eng03XwBuyJ/JQeEOb09+WEJcHuN/qse2Telf3yJ2NPLASm0ed3hCU7YTNni8MNygG
         CjFHTwMGwvRplFEvO0XMq/8xJ0G7RG44GHKtAvcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0352/1146] media: amphion: add lock around vdec_g_fmt
Date:   Wed, 28 Dec 2022 15:31:31 +0100
Message-Id: <20221228144339.724260199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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



