Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB46437C6A9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhELPxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231299AbhELPtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9452661CB1;
        Wed, 12 May 2021 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833118;
        bh=70kosp97N7B5aL+vSZt3412l73+kQTlgiL5T0M9Po9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+hlCSjl1NOWsbYZVrioNYveBKp37EsAbH3ztK9FXE9AxeeZuDvLDmlEiE2yQ8Hpt
         L3Hbza52QHoAzJ0EiQxxyrUA9CzdEuOM6tgGi1QR28P2b7aWDrX9nLwMr1o/7NG2JC
         j5Cb4pAgE3O1QnVLNZ0io8SvFFv2evN/uxvNAu6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Annaliese McDermond <nh6z@nh6z.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 024/601] ASoC: tlv320aic32x4: Increase maximum register in regmap
Date:   Wed, 12 May 2021 16:41:41 +0200
Message-Id: <20210512144828.613282741@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Annaliese McDermond <nh6z@nh6z.net>

commit 29654ed8384e9dbaf4cfba689dbcb664a6ab4bb7 upstream.

AIC32X4_REFPOWERUP was added as a register, but the maximum register value
in the regmap and regmap range was not correspondingly increased.  This
caused an error when this register was attempted to be written.

Fixes: ec96690de82c ("ASoC: tlv320aic32x4: Enable fast charge")
Cc: stable@vger.kernel.org
Signed-off-by: Annaliese McDermond <nh6z@nh6z.net>
Link: https://lore.kernel.org/r/0101017889851cab-ce60cfdb-d88c-43d8-bbd2-7fbf34a0c912-000000@us-west-2.amazonses.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tlv320aic32x4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -577,12 +577,12 @@ static const struct regmap_range_cfg aic
 		.window_start = 0,
 		.window_len = 128,
 		.range_min = 0,
-		.range_max = AIC32X4_RMICPGAVOL,
+		.range_max = AIC32X4_REFPOWERUP,
 	},
 };
 
 const struct regmap_config aic32x4_regmap_config = {
-	.max_register = AIC32X4_RMICPGAVOL,
+	.max_register = AIC32X4_REFPOWERUP,
 	.ranges = aic32x4_regmap_pages,
 	.num_ranges = ARRAY_SIZE(aic32x4_regmap_pages),
 };


