Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBEF4F2E16
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbiDEIet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbiDEIUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAE256200;
        Tue,  5 Apr 2022 01:13:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29CF160B0A;
        Tue,  5 Apr 2022 08:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD46C385A0;
        Tue,  5 Apr 2022 08:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146413;
        bh=3LxEPkMJu4WUWNwLsa7IzbFHRo3wh5QvDBNDMq0dVUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLDDgC0P4EXFm+rlWaSYnBD2Chua7UTPIB/HULjK+82SeDj52tkrvjM8VXIrMQ7Nx
         nBlQvTJy9bLYLqcRiYi/oqrJQP0qHkSiJslkRDl6dWv5inoFKRCi1iH9SAFer+YFRW
         We+H3UDuLlWX8pWHY3mweuBn8sjuFX+UtUhY7u8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0717/1126] pps: clients: gpio: Propagate return value from pps_gpio_probe
Date:   Tue,  5 Apr 2022 09:24:24 +0200
Message-Id: <20220405070428.641244285@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit abaca3179b41d4b3b115f27814ee36f6fb45e897 ]

If the pps-gpio driver was probed prior to the GPIO device it uses, the
devm_gpiod_get call returned an -EPROBE_DEFER error, but pps_gpio_probe
replaced that error code with -EINVAL, causing the pps-gpio probe to
fail and not be retried later. Propagate the error return value so that
deferred probe works properly.

Fixes: 161520451dfa (pps: new client driver using GPIO)
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/20220112205214.2060954-1-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 35799e6401c9..2f4b11b4dfcd 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -169,7 +169,7 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	/* GPIO setup */
 	ret = pps_gpio_setup(dev);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	/* IRQ setup */
 	ret = gpiod_to_irq(data->gpio_pin);
-- 
2.34.1



