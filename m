Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798825419F3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378435AbiFGV1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378310AbiFGVYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB588227CE3;
        Tue,  7 Jun 2022 12:01:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 492F6617CC;
        Tue,  7 Jun 2022 19:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A0AC385A2;
        Tue,  7 Jun 2022 19:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628464;
        bh=O6lEeVseCgQ3fG2NYydwpUQZ5nDy0o6c4ymQU+0Wgf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2N9DDnZhGfaLhec4Ctlit5QcYrt8jxc4HEMBrD84mZ0Ksd0PkME3d6CAE/sKSi7J4
         k8mdAol/qAJlQP9bxdXIQDrRApKuFKNhg60p8zKLuYj0D0iqip7U8pV98FDtYPAQW8
         FwqehijskArJxBWh+68q/SebeMHjPjdtGMyoDdhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 340/879] media: amphion: fix decoders interlaced field
Date:   Tue,  7 Jun 2022 18:57:38 +0200
Message-Id: <20220607165012.728189798@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit d9a6a70d65cd7d25bad00580157ad660330023d8 ]

For interlaced frame, the amphion vpu will store the
two fields sequential into one buffer, top-bottom order
so the field should be set to V4L2_FIELD_SEQ_TB.
fix the previous bug that set it to V4L2_FIELD_SEQ_BT wrongly.

Fixes: 6de8d628df6e ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index 8f8dfd6ce2c6..c0dfede11ab7 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -782,7 +782,7 @@ static void vdec_init_fmt(struct vpu_inst *inst)
 	if (vdec->codec_info.progressive)
 		inst->cap_format.field = V4L2_FIELD_NONE;
 	else
-		inst->cap_format.field = V4L2_FIELD_SEQ_BT;
+		inst->cap_format.field = V4L2_FIELD_SEQ_TB;
 	if (vdec->codec_info.color_primaries == V4L2_COLORSPACE_DEFAULT)
 		vdec->codec_info.color_primaries = V4L2_COLORSPACE_REC709;
 	if (vdec->codec_info.transfer_chars == V4L2_XFER_FUNC_DEFAULT)
-- 
2.35.1



