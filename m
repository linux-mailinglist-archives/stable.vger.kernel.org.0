Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B8460AC07
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiJXOB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236891AbiJXOAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90308E73A;
        Mon, 24 Oct 2022 05:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FED612A4;
        Mon, 24 Oct 2022 12:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FD6C433D6;
        Mon, 24 Oct 2022 12:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615531;
        bh=lU1rMge4AvOB32EqEc1cYUnGuxCTzQQf26R06XK4qiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdJ2SXyiXRMcHbC3S+ee3oVgfPWInrXJpQWd+SFys6Ovji/bkwtGcC4v0GXQTv9Q6
         G0ppDy3dHaL1jgYq+cyNEg4loxaTyWoA+Rq+3vV/tvd7H2qKGnOnHtHzDF4DWDa7NH
         fkemlRGF7QELQ0PWIQ3XRDBDA/rA1+ZNRNK8sYVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/530] media: meson: vdec: add missing clk_disable_unprepare on error in vdec_hevc_start()
Date:   Mon, 24 Oct 2022 13:30:30 +0200
Message-Id: <20221024113057.997955984@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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



