Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2365F49A351
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366238AbiAXXwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845416AbiAXXMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:12:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F59C067A52;
        Mon, 24 Jan 2022 13:19:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE23761491;
        Mon, 24 Jan 2022 21:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91117C340E7;
        Mon, 24 Jan 2022 21:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059163;
        bh=4k89oqbZmtEv29d2sp//Spqf8XbzF1OSGGeSkQN8Vws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spxP35QjNwK/HH+zpzLG46dZ5Bo/A1N2FMVa5KevKpZq74aLFfkdYiE9nTHW9n+c4
         eraF1CSj3dWXiQSv6dkt5njXKLF9eK/i49lBtpC5wZ/6rHGkEBzsVtTBW00Rt3tnPN
         pG6+/KlZdbZOyTJUWj4n1Jm7ndFgoiDcBXEjf9cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0525/1039] ASoC: imx-card: Need special setting for ak4497 on i.MX8MQ
Date:   Mon, 24 Jan 2022 19:38:34 +0100
Message-Id: <20220124184142.932239769@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 6f06afd23b16a..96ac1e465fade 100644
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



