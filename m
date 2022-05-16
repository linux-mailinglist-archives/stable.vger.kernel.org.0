Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C6E528F2E
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348644AbiEPTw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346400AbiEPTu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7E743ECF;
        Mon, 16 May 2022 12:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A8A66158C;
        Mon, 16 May 2022 19:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359C6C385AA;
        Mon, 16 May 2022 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730315;
        bh=7EGulCmb0/+blDSK/gzkijpL6zfAOH8X+sgsDtOgLIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IK0KAebXkV7KuFQ1cfDjjYGVBLcVixL+mn6KirrFsY6+G2mvWB9/bGYOvfz0o1sV7
         VMbMJpnGtgSidAr88XCPHWecw+hIOVKPEZ8NFDW5ZyeF5LsrbKsNtcTq1PqqYIM6hS
         hM93bAUIroI6dGmCKs2GMZrLoHKnHyXAkmdg4u0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/66] net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral
Date:   Mon, 16 May 2022 21:36:25 +0200
Message-Id: <20220516193620.142987841@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 6b77c06655b8a749c1a3d9ebc51e9717003f7e5a ]

The interrupt controller supplying the Wake-on-LAN interrupt line maybe
modular on some platforms (irq-bcm7038-l1.c) and might be probed at a
later time than the GENET driver. We need to specifically check for
-EPROBE_DEFER and propagate that error to ensure that we eventually
fetch the interrupt descriptor.

Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
Fixes: 5b1f0e62941b ("net: bcmgenet: Avoid touching non-existent interrupt")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20220511031752.2245566-1-f.fainelli@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 9ffdaa84ba12..e0a6a2e62d23 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3946,6 +3946,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		goto err;
 	}
 	priv->wol_irq = platform_get_irq_optional(pdev, 2);
+	if (priv->wol_irq == -EPROBE_DEFER) {
+		err = priv->wol_irq;
+		goto err;
+	}
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
-- 
2.35.1



