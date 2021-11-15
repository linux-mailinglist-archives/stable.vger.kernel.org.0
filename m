Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0504511C1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243928AbhKOTOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244129AbhKOTKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:10:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C14C63282;
        Mon, 15 Nov 2021 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000317;
        bh=+WyH8aD4Lqsa7S8zDAq1rZOH0rF9Xtsaxn5ytbQGMEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FATUemE6gwsDBJTqxtvo1bV101G44oGBU8BDsLTpzA6p4YlQ2igXYODewWei9FtDi
         RVYCg5I40AOZl5vEqPv8q4cVaVIUkNmeJNT6jxr+KrI5YKXzrobPRw/uzGwrGRfHBi
         9ItVnyw3rfuL88xoyb3DagXaw4ClM2gwLu35HPto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 617/849] ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_DEFER
Date:   Mon, 15 Nov 2021 18:01:40 +0100
Message-Id: <20211115165441.118302776@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 2645cc7ea29c4..679b1e7cd0c5b 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1926,8 +1926,9 @@ static int cs42l42_i2c_probe(struct i2c_client *i2c_client,
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



