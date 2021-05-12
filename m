Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5D437CAE4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbhELQcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241233AbhELQ04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DCB761622;
        Wed, 12 May 2021 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834652;
        bh=70kosp97N7B5aL+vSZt3412l73+kQTlgiL5T0M9Po9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYpy5F6McUlpPxKYn3NbNSYECKrVbvWX41RcMOHfoTm4JCGReZlSgvu8Zo9dMz4dr
         a0yvm0gRL2BLQ+elM8JbWTe7Bo2mZNH6Q9oDxxK5MrX6XHTpF1xmCZeGP+pvb3MwK0
         x4TyEfvQFRWM3uBNZSc1XCGyOUwLzrRUcXOA/07s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Annaliese McDermond <nh6z@nh6z.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 029/677] ASoC: tlv320aic32x4: Increase maximum register in regmap
Date:   Wed, 12 May 2021 16:41:15 +0200
Message-Id: <20210512144838.194819618@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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


