Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3062529B418
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783320AbgJ0O6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783304AbgJ0O6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E89206F4;
        Tue, 27 Oct 2020 14:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810682;
        bh=ta7CI5Unjs+h0/N1vOjema7h4yq/c9AOY367xUX7QcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mt/+qHIg9/pw0HIPpTCqQCMg18+V8bY7Hmss32Rde/HJbvSGZ/XZP06PaOX8pa9/0
         irN0A/9HrgyPi7IlajziJTn8LVyf5KG0gHV/nAvCrinCokamr8glGBYlBhos4xONsH
         /DVxju3tJo5ySRUj2nUaWygwgv0/gaGyCLbMU/AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Camel Guo <camelg@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 227/633] ASoC: tlv320adcx140: Fix digital gain range
Date:   Tue, 27 Oct 2020 14:49:30 +0100
Message-Id: <20201027135533.327530118@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Camel Guo <camelg@axis.com>

[ Upstream commit 73154aca4a03a2ab4833fd36683feb884af06d4b ]

According to its datasheet, the digital gain should be -100 dB when
CHx_DVOL is 1 and 27 dB when CHx_DVOL is 255. But with the current
dig_vol_tlv, "Digital CHx Out Volume" shows 27.5 dB if CHx_DVOL is 255
and -95.5 dB if CHx_DVOL is 1. This commit fixes this bug.

Fixes: 689c7655b50c ("ASoC: tlv320adcx140: Add the tlv320adcx140 codec driver family")
Signed-off-by: Camel Guo <camelg@axis.com>
Link: https://lore.kernel.org/r/20200908090417.16695-1-camel.guo@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 03fb50175d876..a6273ccb84013 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -154,7 +154,7 @@ static const struct regmap_config adcx140_i2c_regmap = {
 };
 
 /* Digital Volume control. From -100 to 27 dB in 0.5 dB steps */
-static DECLARE_TLV_DB_SCALE(dig_vol_tlv, -10000, 50, 0);
+static DECLARE_TLV_DB_SCALE(dig_vol_tlv, -10050, 50, 0);
 
 /* ADC gain. From 0 to 42 dB in 1 dB steps */
 static DECLARE_TLV_DB_SCALE(adc_tlv, 0, 100, 0);
-- 
2.25.1



