Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029CA657D8E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiL1Po1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiL1PoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A8E1742F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 703E9CE1369
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674D7C433D2;
        Wed, 28 Dec 2022 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242261;
        bh=LPUCkWdKAf58dDEL5vYdlQ86UCsRXdY1X7UX56dTgbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsF48+njmCx/OVI7Bf50o/8VXFq2ZgPXj3necG096H4lPDzjwRJIQobxVSkdIaAGE
         6Ca4uG/Z2ZeIG6AlYjTbEzDwNopbq/X77HJOAbgcqkbE9ClUX5KJM0AkfPxh1u+ThT
         22do2VILQOM6eavRe/sN5iRPeAV3RTv0V6VoYae4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Janne Terho <janne.terho@ouman.fi>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 581/731] rtc: pcf85063: fix pcf85063_clkout_control
Date:   Wed, 28 Dec 2022 15:41:28 +0100
Message-Id: <20221228144313.392617901@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c2d12e85336f6d4172fb2bab5935027c446d7343 ]

pcf85063_clkout_control reads the wrong register but then update the
correct one.

Reported-by: Janne Terho <janne.terho@ouman.fi>
Fixes: 8c229ab6048b ("rtc: pcf85063: Add pcf85063 clkout control to common clock framework")
Link: https://lore.kernel.org/r/20221211223553.59955-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85063.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index 3e2837722667..bf2e370907b7 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -422,7 +422,7 @@ static int pcf85063_clkout_control(struct clk_hw *hw, bool enable)
 	unsigned int buf;
 	int ret;
 
-	ret = regmap_read(pcf85063->regmap, PCF85063_REG_OFFSET, &buf);
+	ret = regmap_read(pcf85063->regmap, PCF85063_REG_CTRL2, &buf);
 	if (ret < 0)
 		return ret;
 	buf &= PCF85063_REG_CLKO_F_MASK;
-- 
2.35.1



