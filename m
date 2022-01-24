Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DFE49A376
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365493AbiAXXvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573401AbiAXVoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880B2C034036;
        Mon, 24 Jan 2022 12:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F0D61505;
        Mon, 24 Jan 2022 20:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9D3C340E5;
        Mon, 24 Jan 2022 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056330;
        bh=77zrGaV5IqpQkO6T/hLSsP09WV79+S1+/eQmIp2qcPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7mULvmU9Uivd4mF2SVkJHyWE4MSZeARYBKjwuBKy30csi3nFXRKWFJpg4UJzdnPz
         KGnpUVBQ9OJT86vVmj1Cpyae1ucS8k96mwBiD7NF3CElAtmx42/6FPtoH6FotWj01N
         EcaYcvqIZsz02LgWbaS6zXaQNYc41DZ9Bj3yyCq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/846] ASoC: imx-card: improve the sound quality for low rate
Date:   Mon, 24 Jan 2022 19:39:26 +0100
Message-Id: <20220124184116.482259576@linuxfoundation.org>
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

[ Upstream commit 3969341813eb56d2dfc39bb64229359a6ae3c195 ]

According to RM, on auto mode:
For codec AK4458 and AK4497, the lowest ratio of MLCK/FS is 256
if sample rate is 8kHz-48kHz,
For codec AK5558, the lowest ratio of MLCK/FS is 512 if sample
rate is 8kHz-48kHz.

With these setting the sound quality for 8kHz-48kHz can be improved.

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1641292835-19085-4-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index ad15974a22c3f..db947180617a6 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -120,7 +120,7 @@ struct imx_card_data {
 
 static struct imx_akcodec_fs_mul ak4458_fs_mul[] = {
 	/* Normal, < 32kHz */
-	{ .rmin = 8000,   .rmax = 24000,  .wmin = 1024, .wmax = 1024, },
+	{ .rmin = 8000,   .rmax = 24000,  .wmin = 256,  .wmax = 1024, },
 	/* Normal, 32kHz */
 	{ .rmin = 32000,  .rmax = 32000,  .wmin = 256,  .wmax = 1024, },
 	/* Normal */
@@ -151,8 +151,8 @@ static struct imx_akcodec_fs_mul ak4497_fs_mul[] = {
 	 * Table 7      - mapping multiplier and speed mode
 	 * Tables 8 & 9 - mapping speed mode and LRCK fs
 	 */
-	{ .rmin = 8000,   .rmax = 32000,  .wmin = 1024, .wmax = 1024, }, /* Normal, <= 32kHz */
-	{ .rmin = 44100,  .rmax = 48000,  .wmin = 512,  .wmax = 512, }, /* Normal */
+	{ .rmin = 8000,   .rmax = 32000,  .wmin = 256,  .wmax = 1024, }, /* Normal, <= 32kHz */
+	{ .rmin = 44100,  .rmax = 48000,  .wmin = 256,  .wmax = 512, }, /* Normal */
 	{ .rmin = 88200,  .rmax = 96000,  .wmin = 256,  .wmax = 256, }, /* Double */
 	{ .rmin = 176400, .rmax = 192000, .wmin = 128,  .wmax = 128, }, /* Quad */
 	{ .rmin = 352800, .rmax = 384000, .wmin = 128,  .wmax = 128, }, /* Oct */
@@ -164,7 +164,7 @@ static struct imx_akcodec_fs_mul ak4497_fs_mul[] = {
  * (Table 4 from datasheet)
  */
 static struct imx_akcodec_fs_mul ak5558_fs_mul[] = {
-	{ .rmin = 8000,   .rmax = 32000,  .wmin = 1024, .wmax = 1024, },
+	{ .rmin = 8000,   .rmax = 32000,  .wmin = 512,  .wmax = 1024, },
 	{ .rmin = 44100,  .rmax = 48000,  .wmin = 512,  .wmax = 512, },
 	{ .rmin = 88200,  .rmax = 96000,  .wmin = 256,  .wmax = 256, },
 	{ .rmin = 176400, .rmax = 192000, .wmin = 128,  .wmax = 128, },
-- 
2.34.1



