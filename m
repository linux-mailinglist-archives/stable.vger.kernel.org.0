Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C484F7056
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238261AbiDGBV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239312AbiDGBTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:19:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D02F190B4A;
        Wed,  6 Apr 2022 18:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE8161DCE;
        Thu,  7 Apr 2022 01:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3B7C385A1;
        Thu,  7 Apr 2022 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294059;
        bh=J0gKT3Ofnrpn5xAm/AA3kEx/902/31ohvQqjk4KtKTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ym4YEKPUVV3Ly/bzs8llzGWtOnQnlSYHpjkFygX5NctxWstEYT/gAJ+CbtiHj5rAO
         zD14WF6AJnuNOJ8MCVCNU1a0ODhn15+TwE58CIMm0zd3e1bSddYGqv6wxt6PHj9tdh
         q5eA5tvQaUmlhobI8kKmfZBgS9/pvQmt8WsRwRnbUXFY5C2dODMkSB5n4kwxi4Rv7P
         mjIvOH581apPwiLEDQOKVtrkXGsb7DOW9bgKwySywUTsv67wLorGiUTr6VzPUitJN6
         CJG3E0a0CCvkjYaH2lSdWAI57NaSFc1ouAuHpUjKTt2GGGduHB96TDRbeai4/XzMqp
         RLYKH6pGP8vzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugo Villeneuve <hvilleneuve@dimonoff.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/25] rtc: pcf2127: fix bug when reading alarm registers
Date:   Wed,  6 Apr 2022 21:13:51 -0400
Message-Id: <20220407011413.114662-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011413.114662-1-sashal@kernel.org>
References: <20220407011413.114662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 73ce05302007eece23a6acb7dc124c92a2209087 ]

The first bug is that reading the 5 alarm registers results in a read
operation of 20 bytes. The reason is because the destination buffer is
defined as an array of "unsigned int", and we use the sizeof()
operator on this array to define the bulk read count.

The second bug is that the read value is invalid, because we are
indexing the destination buffer as integers (4 bytes), instead of
indexing it as u8.

Changing the destination buffer type to u8 fixes both problems.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220208162908.3182581-1-hugo@hugovil.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf2127.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index f0a6861ff3ae..715513311ece 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -366,7 +366,8 @@ static int pcf2127_watchdog_init(struct device *dev, struct pcf2127 *pcf2127)
 static int pcf2127_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pcf2127 *pcf2127 = dev_get_drvdata(dev);
-	unsigned int buf[5], ctrl2;
+	u8 buf[5];
+	unsigned int ctrl2;
 	int ret;
 
 	ret = regmap_read(pcf2127->regmap, PCF2127_REG_CTRL2, &ctrl2);
-- 
2.35.1

