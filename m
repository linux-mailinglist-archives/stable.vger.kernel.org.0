Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C9E5586CD
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiFWSRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiFWSQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:16:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0AF4F465;
        Thu, 23 Jun 2022 10:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99B6CB824B8;
        Thu, 23 Jun 2022 17:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118C0C3411B;
        Thu, 23 Jun 2022 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004952;
        bh=qvQ+DoApFMSYGyUqTdbIgWetXlmQvXHjNbqiyeHETKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fS9rltE3QuWPp7uiKh7tqCEHoyQ41Pgimw3oGD3bruula+xtapZWJ5Q7DTxQJJKWs
         nF+bjFTpZ3Uk/evLLPuXbVMpmDjQaVMWXouCU3LE0ctMsyJwWKIM3nKDunGb3vsqoJ
         5zXHknaaSQVzG+1X3BUwoKRXAQBpHLpOxwJTyrvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/234] tty: goldfish: Fix free_irq() on remove
Date:   Thu, 23 Jun 2022 18:44:29 +0200
Message-Id: <20220623164348.767165728@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 499e13aac6c762e1e828172b0f0f5275651d6512 ]

Pass the correct dev_id to free_irq() to fix this splat when the driver
is unbound:

 WARNING: CPU: 0 PID: 30 at kernel/irq/manage.c:1895 free_irq
 Trying to free already-free IRQ 65
 Call Trace:
  warn_slowpath_fmt
  free_irq
  goldfish_tty_remove
  platform_remove
  device_remove
  device_release_driver_internal
  device_driver_detach
  unbind_store
  drv_attr_store
  ...

Fixes: 465893e18878e119 ("tty: goldfish: support platform_device with id -1")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20220609141704.1080024-1-vincent.whitchurch@axis.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/goldfish.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index abc84d84f638..9180ca5e4dcd 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -428,7 +428,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 	tty_unregister_device(goldfish_tty_driver, qtty->console.index);
 	iounmap(qtty->base);
 	qtty->base = NULL;
-	free_irq(qtty->irq, pdev);
+	free_irq(qtty->irq, qtty);
 	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
-- 
2.35.1



