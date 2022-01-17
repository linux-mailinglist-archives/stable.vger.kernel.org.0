Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE4F490D73
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbiAQRDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:03:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49784 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238322AbiAQRBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 472BFB81131;
        Mon, 17 Jan 2022 17:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3955C36AED;
        Mon, 17 Jan 2022 17:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438904;
        bh=huBJE9+l2qjWsYgu4trs0SBLj5tSgk3OSGlpb5Ca0FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIlGG2+HBnY7tZVNfGp/411ALYZlQ2OOUbco6tqgATb2oMCSBdNXmzKVG9U+F5TpZ
         e6T6AXtVvpXBDbzesSJ7ICBPhRBNDV3R+TpcEeY2DVovaLf3k7Xdyve+M8TIPsosJa
         Hl3Dkh+o+D/+YeSMsyizQs8NlNbzy0Pzk9kYBx8cjrp4Mbjp10mr+mLeD+/13Z7J2x
         lYFstEQmad4oNTLh3ylR+YDSJzGgTcGY4TlMt8R6RzHoRzvjaPUqi4zSmnzjk9XL2o
         ettJagrq+N/wbBrujrKAJ0Q4rDrn9ZsxAxJk3cppAV0hFhKzKtTqdRoFTsCI8xM3As
         wsjtyhFXSeRUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Guojin <ye.guojin@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nicoleotsuka@gmail.com,
        Xiubo.Lee@gmail.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, shawnguo@kernel.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 07/44] ASoC: imx-hdmi: add put_device() after of_find_device_by_node()
Date:   Mon, 17 Jan 2022 12:00:50 -0500
Message-Id: <20220117170127.1471115-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

[ Upstream commit f670b274f7f6f4b2722d7f08d0fddf606a727e92 ]

This was found by coccicheck:
./sound/soc/fsl/imx-hdmi.c,209,1-7,ERROR  missing put_device; call
of_find_device_by_node on line 119, but without a corresponding object
release within this function.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Link: https://lore.kernel.org/r/20211110002910.134915-1-ye.guojin@zte.com.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/imx-hdmi.c b/sound/soc/fsl/imx-hdmi.c
index 34a0dceae6216..ef8d7a65ebc61 100644
--- a/sound/soc/fsl/imx-hdmi.c
+++ b/sound/soc/fsl/imx-hdmi.c
@@ -145,6 +145,8 @@ static int imx_hdmi_probe(struct platform_device *pdev)
 	data->dai.capture_only = false;
 	data->dai.init = imx_hdmi_init;
 
+	put_device(&cpu_pdev->dev);
+
 	if (of_node_name_eq(cpu_np, "sai")) {
 		data->cpu_priv.sysclk_id[1] = FSL_SAI_CLK_MAST1;
 		data->cpu_priv.sysclk_id[0] = FSL_SAI_CLK_MAST1;
-- 
2.34.1

