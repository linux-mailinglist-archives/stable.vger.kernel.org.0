Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE99945C0B5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344392AbhKXNKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244817AbhKXNJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B55F961A64;
        Wed, 24 Nov 2021 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757637;
        bh=8uhJ4tZxOM8McXwyQrVw4Y0U1+Yd1v9TZdBMn+L4vLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjATG34eeNNAgUv3xs91zddksGni7RIc3asmwPd9faWm6I+KdGSBkiElopIpa2Y5Z
         bd1eOlXjpoag42GbW+sj7yY48+Kp1hC4cA4v5tg0vnakxUM8LBZ6DFHjAW/e/W6iIX
         4dL/ctgVyj5qz7yvagJd4DHKgQTIAUeyUErN+TO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/323] ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_DEFER
Date:   Wed, 24 Nov 2021 12:56:25 +0100
Message-Id: <20211124115725.520480882@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 0306988789d9d91a18ff70bd2bf165d3ae0ef1dd ]

The driver can run without an interrupt so if devm_request_threaded_irq()
failed, the probe() just carried on. But if this was EPROBE_DEFER the
driver would continue without an interrupt instead of deferring to wait
for the interrupt to become available.

Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20211015133619.4698-6-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index f9d6534d4632d..9471ba17e371b 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1799,8 +1799,9 @@ static int cs42l42_i2c_probe(struct i2c_client *i2c_client,
 			NULL, cs42l42_irq_thread,
 			IRQF_ONESHOT | IRQF_TRIGGER_LOW,
 			"cs42l42", cs42l42);
-
-	if (ret != 0)
+	if (ret == -EPROBE_DEFER)
+		goto err_disable;
+	else if (ret != 0)
 		dev_err(&i2c_client->dev,
 			"Failed to request IRQ: %d\n", ret);
 
-- 
2.33.0



