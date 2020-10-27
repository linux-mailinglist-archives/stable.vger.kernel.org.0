Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5614429BFA0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815671AbgJ0RED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793611AbgJ0PH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C82C206F4;
        Tue, 27 Oct 2020 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811246;
        bh=g6dP+BPrfb98trzPWGgjmNStse5pQDADMfVlHwEzsko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsWkGahyLgSVKT7L4IX/BOuOzquIxGtzbIq+tnjTPx9LawZvtg9xZ8s8oGRuREP6D
         LV19AGEDZsS2lvOAbheTxW9NG31i/fr5kobLAOYwm99kl4+eSuSXE9j+2vTFgnCLzH
         ZCWJXBFZHUOZ1/SO7kiA6ICYDHGTaWsPDo3w132s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 426/633] rtc: ds1307: Clear OSF flag on DS1388 when setting time
Date:   Tue, 27 Oct 2020 14:52:49 +0100
Message-Id: <20201027135542.702283988@linuxfoundation.org>
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

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit f471b05f76e4b1b6ba07ebc7681920a5c5b97c5d ]

Ensure the OSF flag is cleared on the DS1388 when the clock is set.

Fixes: df11b323b16f ("rtc: ds1307: handle oscillator failure flags for ds1388 variant")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200818013543.4283-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 49702942bb086..70b198423deba 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -352,6 +352,10 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 		regmap_update_bits(ds1307->regmap, DS1340_REG_FLAG,
 				   DS1340_BIT_OSF, 0);
 		break;
+	case ds_1388:
+		regmap_update_bits(ds1307->regmap, DS1388_REG_FLAG,
+				   DS1388_BIT_OSF, 0);
+		break;
 	case mcp794xx:
 		/*
 		 * these bits were cleared when preparing the date/time
-- 
2.25.1



