Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9086E499401
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388190AbiAXUiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350425AbiAXUcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:32:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BFC9B8121A;
        Mon, 24 Jan 2022 20:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C3FC340E7;
        Mon, 24 Jan 2022 20:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056324;
        bh=URWHLSJH7EmPR6Venvvxop3L87OYrS7QRxfHT+dHLTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1AX9AgkeVQKCLHECwsqQIKJcBYwg3BmZcixnlEn7WXCfJsxZVw4Awm7MjIb6nigj
         Nl5CXH/W5uR5iFBV/8Mr/4r2IT6terUB7gtPrzn5rHNJLy6/q65ZmxGQNmC1XK6iaP
         qbVT2QYCacNYv7g2mmzkXTBoYALLrNVxf6mB1x2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/846] ASoC: imx-card: Need special setting for ak4497 on i.MX8MQ
Date:   Mon, 24 Jan 2022 19:39:24 +0100
Message-Id: <20220124184116.415121458@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 3349b3d0c63b8b6fcca58156d72407f0b2e101ac ]

The SAI on i.MX8MQ don't support one2one ratio for mclk:bclk, so
the mclk frequency exceeds the supported range of codec for
the case that sample rate is larger than 705kHZ and format is
S32_LE. Update the supported width for such case.

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1641292835-19085-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 58fd0639a0698..f6b54de76dc3c 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -553,8 +553,23 @@ static int imx_card_parse_of(struct imx_card_data *data)
 			link_data->cpu_sysclk_id = FSL_SAI_CLK_MAST1;
 
 			/* sai may support mclk/bclk = 1 */
-			if (of_find_property(np, "fsl,mclk-equal-bclk", NULL))
+			if (of_find_property(np, "fsl,mclk-equal-bclk", NULL)) {
 				link_data->one2one_ratio = true;
+			} else {
+				int i;
+
+				/*
+				 * i.MX8MQ don't support one2one ratio, then
+				 * with ak4497 only 16bit case is supported.
+				 */
+				for (i = 0; i < ARRAY_SIZE(ak4497_fs_mul); i++) {
+					if (ak4497_fs_mul[i].rmin == 705600 &&
+					    ak4497_fs_mul[i].rmax == 768000) {
+						ak4497_fs_mul[i].wmin = 32;
+						ak4497_fs_mul[i].wmax = 32;
+					}
+				}
+			}
 		}
 
 		link->cpus->of_node = args.np;
-- 
2.34.1



