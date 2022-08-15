Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B777594662
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352128AbiHOWzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352162AbiHOWxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:53:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14DA7F10C;
        Mon, 15 Aug 2022 12:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FB42B81144;
        Mon, 15 Aug 2022 19:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F727C433D7;
        Mon, 15 Aug 2022 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593281;
        bh=keQl0RqzTCXOjfuUaTm3QR3v50m15zFuKa0dQ4j6y1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9j8aEMAR5LCQNrfKbKnfoxyq4Pr/HIs4z3RsrOY9R254XN24jgH0kwHarp95xnaJ
         7pt3d3USjMx1e6TtU9cl7DYzrUX+rsDiFRPdHR9FVdnFT16M52a00Pt7jDdoVS5L6y
         Jlc1xTW1Xm2PiNFXBLOIEk32c5yLPdlhVPERj9os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guo Mengqi <guomengqi3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0922/1095] serial: 8250_bcm2835aux: Add missing clk_disable_unprepare()
Date:   Mon, 15 Aug 2022 20:05:21 +0200
Message-Id: <20220815180507.406769177@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Guo Mengqi <guomengqi3@huawei.com>

[ Upstream commit b9f1736e475dba0d6da48fdcb831248ab1597886 ]

The error path when get clock frequency fails in bcm2835aux_serial
driver does not correctly disable the clock.

This flaw was found using a static analysis tool "Hulk Robot", which
reported the following warning when analyzing linux-next/master:

    drivers/tty/serial/8250/8250_bcm2835aux.c:
    warning: clk_disable_unprepare_missing.cocci

The cocci script checks for the existence of clk_disable_unprepare()
paired with clk_prepare_enable().

Add the missing clk_disable_unprepare() to the error path.

Fixes: fcc446c8aa63 ("serial: 8250_bcm2835aux: Add ACPI support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Guo Mengqi <guomengqi3@huawei.com>
Link: https://lore.kernel.org/r/20220715023312.37808-1-guomengqi3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_bcm2835aux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_bcm2835aux.c b/drivers/tty/serial/8250/8250_bcm2835aux.c
index 2a1226a78a0c..21939bb44613 100644
--- a/drivers/tty/serial/8250/8250_bcm2835aux.c
+++ b/drivers/tty/serial/8250/8250_bcm2835aux.c
@@ -166,8 +166,10 @@ static int bcm2835aux_serial_probe(struct platform_device *pdev)
 	uartclk = clk_get_rate(data->clk);
 	if (!uartclk) {
 		ret = device_property_read_u32(&pdev->dev, "clock-frequency", &uartclk);
-		if (ret)
-			return dev_err_probe(&pdev->dev, ret, "could not get clk rate\n");
+		if (ret) {
+			dev_err_probe(&pdev->dev, ret, "could not get clk rate\n");
+			goto dis_clk;
+		}
 	}
 
 	/* the HW-clock divider for bcm2835aux is 8,
-- 
2.35.1



