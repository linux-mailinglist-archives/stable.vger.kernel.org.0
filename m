Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CC6551C59
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245617AbiFTNLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344454AbiFTNKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93DD1CFC4;
        Mon, 20 Jun 2022 06:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3011B811CC;
        Mon, 20 Jun 2022 13:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC80C3411B;
        Mon, 20 Jun 2022 13:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730147;
        bh=9iz+eAWx5+Ws2N52jR5JJFMW77Zr3QxK4wBKjTOUjec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6Xf7WN4z1fsZe/JUj1fCXtFSMGXrKdGlTcHj6BYWlOaoY1aJSPBbF1vCsqUB+1rz
         msVjX7GMwUQtAhD6AXHhizaMb834QOVn70ogj5YdxV9Un8pfUTLNHIU2diGV8umUbn
         a06sNAZ9HE2CIQCHb+UnvZmyMP6DiFNL7zPaxVOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/84] net: bgmac: Fix an erroneous kfree() in bgmac_remove()
Date:   Mon, 20 Jun 2022 14:51:11 +0200
Message-Id: <20220620124722.309628108@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d7dd6eccfbc95ac47a12396f84e7e1b361db654b ]

'bgmac' is part of a managed resource allocated with bgmac_alloc(). It
should not be freed explicitly.

Remove the erroneous kfree() from the .remove() function.

Fixes: 34a5102c3235 ("net: bgmac: allocate struct bgmac just once & don't copy it")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/a026153108dd21239036a032b95c25b5cece253b.1655153616.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index a5fd161ab5ee..26746197515f 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -323,7 +323,6 @@ static void bgmac_remove(struct bcma_device *core)
 	bcma_mdio_mii_unregister(bgmac->mii_bus);
 	bgmac_enet_remove(bgmac);
 	bcma_set_drvdata(core, NULL);
-	kfree(bgmac);
 }
 
 static struct bcma_driver bgmac_bcma_driver = {
-- 
2.35.1



