Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CBF60AA0F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiJXN23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiJXN0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:26:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF074A99D2;
        Mon, 24 Oct 2022 05:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED42A612E4;
        Mon, 24 Oct 2022 12:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E855C433D6;
        Mon, 24 Oct 2022 12:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614670;
        bh=fx3JHcvtdVhm6G9pDbFUGab8CHujgq2yvps8m0vWMQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUqlAPe8ewP9D1efxyls3W4ryaFHHRMp+0haCnZXX2iw6P3blHzvsD9jRSlUBzSuH
         Gp73W5J7kGwfDw8vWVIKeKxF71YmutXXCxcvE/zzN0CdL4m2hEUMf5H4pCriGhx3F1
         wYPwhaoQRpDfeZUawfQEpZBydPf7rQS8WqbggIkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Vasilugin <vasilugin@yandex.ru>,
        Daniel Golle <daniel@makrotopia.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/390] wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
Date:   Mon, 24 Oct 2022 13:31:55 +0200
Message-Id: <20221024113036.530957602@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit eeb50acf15762b61921f9df18663f839f387c054 ]

Set correct TX_SW_CFG1 MAC register as it is done also in v3 of the
vendor driver[1].

[1]: https://gitlab.com/dm38/padavan-ng/-/blob/master/trunk/proprietary/rt_wifi/rtpci/3.0.X.X/mt76x2/chips/rt6352.c#L531
Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/4be38975ce600a34249e12d09a3cb758c6e71071.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 3f2c10c2aaf8..327f19cae4d7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5849,7 +5849,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0001);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
-- 
2.35.1



