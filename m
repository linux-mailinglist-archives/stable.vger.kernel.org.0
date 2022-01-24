Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DDD499C5E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579136AbiAXWFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577990AbiAXWBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:01:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E87C02415F;
        Mon, 24 Jan 2022 12:41:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECE656153D;
        Mon, 24 Jan 2022 20:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4746C340E7;
        Mon, 24 Jan 2022 20:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056871;
        bh=huBJE9+l2qjWsYgu4trs0SBLj5tSgk3OSGlpb5Ca0FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQ/u/gs5SsEPiSudaty+VZDWMdlGG4sJM3pvutBcM/8g+MXpjE++aZK51zuDZqn99
         9jQHUgli57ocTENl7T1U3h0VP1SBp7nfgEl/M7qsbRxwKQ2YCYQZq0lwZXEq8r4Ca4
         +RlLvsChU3kpuI5l1kh6N+/Jlk+4NUOceiMDoR5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 628/846] ASoC: imx-hdmi: add put_device() after of_find_device_by_node()
Date:   Mon, 24 Jan 2022 19:42:25 +0100
Message-Id: <20220124184122.694324615@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



