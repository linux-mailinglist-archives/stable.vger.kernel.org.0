Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC30A529150
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351317AbiEPUDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346941AbiEPT4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:56:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E22947ACE;
        Mon, 16 May 2022 12:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8993560ABE;
        Mon, 16 May 2022 19:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C44CC385AA;
        Mon, 16 May 2022 19:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730559;
        bh=GZmT6UyDgzYGY7TSs0kpvPrztQ8Bwwl5DZCnoBnMDac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwk3n0bOcPT1ibDGtrMYlHyWevz3Pxj4OTFN7NoAnvFwjefN0LByX6AZ3JGWQJNB5
         8fSUQqzQlpf9Sv/wTR3JFl5CjOeqKD+zGevT+FLMM2jFBgszuzAn9FpL3nOeF0GdTW
         iFMaSDYBOWYsVHmBymc4qaAXC4uv5R8Pedv9FI3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/102] net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral
Date:   Mon, 16 May 2022 21:36:11 +0200
Message-Id: <20220516193625.065740411@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
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
index 8bcc39b1575c..ea1391753752 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3950,6 +3950,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
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



