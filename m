Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCC65941FF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiHOVCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347331AbiHOVBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:01:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA03C991A;
        Mon, 15 Aug 2022 12:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96019B81106;
        Mon, 15 Aug 2022 19:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F260BC433D6;
        Mon, 15 Aug 2022 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590823;
        bh=HoKtzkTygzstL7GC29SCUfat8VCVZu8TXTYJkxcN2bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgyNNkAVQBYQFNtqm2LjCzqhfdqFYM7YwH2Mcy9mUnH4G32kMquKddmUxfuJ86D4t
         n1plHC1aqFci2wvPhEE6LYCZZsepdckyFXRHQwpjUW40xFW95s6WVRFhCN5Gm5Wkca
         13RhUPE2w2ipBr1OGd2Kh26qmWWlEoa6eqa4g2UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Dong <yunfei.dong@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0382/1095] media: mediatek: vcodec: Fix non subdev architecture open power fail
Date:   Mon, 15 Aug 2022 19:56:21 +0200
Message-Id: <20220815180445.490635507@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 083f54a7c9c66496b9d9f3c50dfdca24e6aa7012 ]

According to subdev_bitmap bit value to open hardware power, need to
set subdev_bitmap value for non subdev architecture.

Fixes: c05bada35f01 ("media: mtk-vcodec: Add to support multi hardware decode")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
index bd1ee9901da0..d5c94845ea42 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
@@ -393,6 +393,8 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 			mtk_v4l2_err("Main device of_platform_populate failed.");
 			goto err_reg_cont;
 		}
+	} else {
+		set_bit(MTK_VDEC_CORE, dev->subdev_bitmap);
 	}
 
 	ret = video_register_device(vfd_dec, VFL_TYPE_VIDEO, -1);
-- 
2.35.1



