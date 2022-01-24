Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5847D49A35B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366267AbiAXXwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845408AbiAXXMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:12:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6B8C09F4B6;
        Mon, 24 Jan 2022 13:19:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93D20B80FA1;
        Mon, 24 Jan 2022 21:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4D9C340E4;
        Mon, 24 Jan 2022 21:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059169;
        bh=K5eKq+0HrMybBiSNveured9NxZMCaK86vy2yBY9oE8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcTqC2J29Kj9xYjCvEDnA816dCV4lGv+73mpRYfyst5jRcLWOJUtQBgRf6BLt4EJh
         I8sgkrRJakp+KdpbstySjxEusA+I11OjHD9VyEY09NYRW893v4Pf+/mNlAOpex4V4A
         vs6SKuDp0zsnk+u6UvGUIo1ykzUCNuAqxO04htPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0527/1039] ASoC: imx-card: improve the sound quality for low rate
Date:   Mon, 24 Jan 2022 19:38:36 +0100
Message-Id: <20220124184142.998295878@linuxfoundation.org>
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
index 84a8dcdee9316..c7503a5f7cfbc 100644
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



