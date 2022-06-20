Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5935519AE
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiFTNAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244017AbiFTM7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC5619C15;
        Mon, 20 Jun 2022 05:56:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852E1614DA;
        Mon, 20 Jun 2022 12:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2E2C3411C;
        Mon, 20 Jun 2022 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729757;
        bh=G9sVT9BCC2t1SfzLQZXZjkGeZ3YE+zHFK85LE1yWtJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7erjJ7yy4VvjSivh6EkI2e2uduepLfkVic9nzOFkdTIVueULvaIpSgPY+BlLe5n7
         n6d0vqn0SHtXM0rXGfJDYS4QPkUhi1jpR1m8T04YrPlkeuj4RKISajPKtNsEsR4IBA
         2wrkpM9CDOl1nlQbH2m6iYMqtFnhbKlsPFdOCnKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 064/141] misc: atmel-ssc: Fix IRQ check in ssc_probe
Date:   Mon, 20 Jun 2022 14:50:02 +0200
Message-Id: <20220620124731.431779966@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 1c245358ce0b13669f6d1625f7a4e05c41f28980 ]

platform_get_irq() returns negative error number instead 0 on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: eb1f2930609b ("Driver for the Atmel on-chip SSC on AT32AP and AT91")
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220601123026.7119-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/atmel-ssc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index d6cd5537126c..69f9b0336410 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -232,9 +232,9 @@ static int ssc_probe(struct platform_device *pdev)
 	clk_disable_unprepare(ssc->clk);
 
 	ssc->irq = platform_get_irq(pdev, 0);
-	if (!ssc->irq) {
+	if (ssc->irq < 0) {
 		dev_dbg(&pdev->dev, "could not get irq\n");
-		return -ENXIO;
+		return ssc->irq;
 	}
 
 	mutex_lock(&user_lock);
-- 
2.35.1



