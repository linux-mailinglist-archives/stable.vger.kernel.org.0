Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3FE6087D0
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiJVIGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiJVIFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:05:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB082D52FA;
        Sat, 22 Oct 2022 00:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68A98B82DF1;
        Sat, 22 Oct 2022 07:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CAAC433D6;
        Sat, 22 Oct 2022 07:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425129;
        bh=lU1rMge4AvOB32EqEc1cYUnGuxCTzQQf26R06XK4qiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXYArmODH0feiJPoNYwwe31eQNeaO0aGoNx4fvnZjDi/PE1U+6DYflOzKDddoHsR/
         GKXEUfvKL4a+9tNZDgh38qkuM+EbOb2q0KxuPo3ZpXRU8kG7e6wnb1PQjYYFYwNZFU
         z6TDV19zJdMnKDB71ZEw/71oemPSx3NOX86kIGLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 400/717] media: meson: vdec: add missing clk_disable_unprepare on error in vdec_hevc_start()
Date:   Sat, 22 Oct 2022 09:24:39 +0200
Message-Id: <20221022072515.568243594@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Qiang <xuqiang36@huawei.com>

[ Upstream commit 4029372233e13e281f8c387f279f9f064ced3810 ]

Add the missing clk_disable_unprepare() before return
from vdec_hevc_start() in the error handling case.

Fixes: 823a7300340e (“media: meson: vdec: add common HEVC decoder support”)
Signed-off-by: Xu Qiang <xuqiang36@huawei.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/meson/vdec/vdec_hevc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/meson/vdec/vdec_hevc.c b/drivers/staging/media/meson/vdec/vdec_hevc.c
index 9530e580e57a..afced435c907 100644
--- a/drivers/staging/media/meson/vdec/vdec_hevc.c
+++ b/drivers/staging/media/meson/vdec/vdec_hevc.c
@@ -167,8 +167,12 @@ static int vdec_hevc_start(struct amvdec_session *sess)
 
 	clk_set_rate(core->vdec_hevc_clk, 666666666);
 	ret = clk_prepare_enable(core->vdec_hevc_clk);
-	if (ret)
+	if (ret) {
+		if (core->platform->revision == VDEC_REVISION_G12A ||
+		    core->platform->revision == VDEC_REVISION_SM1)
+			clk_disable_unprepare(core->vdec_hevcf_clk);
 		return ret;
+	}
 
 	if (core->platform->revision == VDEC_REVISION_SM1)
 		regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
-- 
2.35.1



