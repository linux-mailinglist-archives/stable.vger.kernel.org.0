Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC873531A8A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbiEWRSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbiEWRRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:17:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D63971A10;
        Mon, 23 May 2022 10:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E50560919;
        Mon, 23 May 2022 17:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D28C385A9;
        Mon, 23 May 2022 17:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326239;
        bh=yC99/wYz6UhC2zfmoGGY9wbZug421pD2Jlmf8Cdzo/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToqgX9ttx3tVM3OxZ8tM4VYkkZPzDMcCR/P1P1DiF3iu1z6znvmXWl3yte5voSk0F
         ss/JqHvw4JLk4sKJZWjGy25OtYKISMfeCY4CheMFBy5N9MTKnZdcugJKsU/Aqgg//y
         gFJTu/IheA74ls+OGhMSaQ2d0IdunF1bK8wF0kSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugo Villeneuve <hvilleneuve@dimonoff.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/132] rtc: pcf2127: fix bug when reading alarm registers
Date:   Mon, 23 May 2022 19:03:49 +0200
Message-Id: <20220523165826.874169570@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 56c58b055dff..43f801107095 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -374,7 +374,8 @@ static int pcf2127_watchdog_init(struct device *dev, struct pcf2127 *pcf2127)
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



