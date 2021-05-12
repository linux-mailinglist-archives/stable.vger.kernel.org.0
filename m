Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D6437CADB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbhELQc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241225AbhELQ0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAD6061DD2;
        Wed, 12 May 2021 15:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834649;
        bh=Ui5LTSvF1Kx7MJccEbiMZwxZiCA2WuRYO9FCSAYKYiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNrkZA47xWZbsWyVumW/9KbUpKfDL5W/MBTa9SwoHfxmOzl9cVbryfLpa0FQDNPdn
         AsaUiuuC4O09hvhJf+D0SGXln9HDeqarQetq5Qc67Xu2QY47mPLjaMQctHkt8Mizsq
         gGv0/tuRviFZbqYnnT824gdAno8LQ/WR8UGyE8mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Annaliese McDermond <nh6z@nh6z.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 028/677] ASoC: tlv320aic32x4: Register clocks before registering component
Date:   Wed, 12 May 2021 16:41:14 +0200
Message-Id: <20210512144838.163128700@linuxfoundation.org>
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

commit 1ca1156cfd69530e6b7cb99943baf90c8bd871a5 upstream.

Clock registration must be performed before the component is
registered.  aic32x4_component_probe attempts to get all the
clocks right off the bat.  If the component is registered before
the clocks there is a race condition where the clocks may not
be registered by the time aic32x4_componet_probe actually runs.

Fixes: d1c859d314d8 ("ASoC: codec: tlv3204: Increased maximum supported channels")
Cc: stable@vger.kernel.org
Signed-off-by: Annaliese McDermond <nh6z@nh6z.net>
Link: https://lore.kernel.org/r/0101017889850206-dcac4cce-8cc8-4a21-80e9-4e4bef44b981-000000@us-west-2.amazonses.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tlv320aic32x4.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -1243,6 +1243,10 @@ int aic32x4_probe(struct device *dev, st
 	if (ret)
 		goto err_disable_regulators;
 
+	ret = aic32x4_register_clocks(dev, aic32x4->mclk_name);
+	if (ret)
+		goto err_disable_regulators;
+
 	ret = devm_snd_soc_register_component(dev,
 			&soc_component_dev_aic32x4, &aic32x4_dai, 1);
 	if (ret) {
@@ -1250,10 +1254,6 @@ int aic32x4_probe(struct device *dev, st
 		goto err_disable_regulators;
 	}
 
-	ret = aic32x4_register_clocks(dev, aic32x4->mclk_name);
-	if (ret)
-		goto err_disable_regulators;
-
 	return 0;
 
 err_disable_regulators:


