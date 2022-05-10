Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FC7521A3D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiEJNy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiEJNqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F5313C095;
        Tue, 10 May 2022 06:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37C0D617F5;
        Tue, 10 May 2022 13:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30573C385A6;
        Tue, 10 May 2022 13:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189479;
        bh=CvPKW8GRBCllmv1GPycQLudYR03UIUxGKRWDVAVIx0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8X1FqHYIpsb0LB6mV2I27jNRejKSKXW6HCDdNjMdcf1NQPQNZL+vR8QmMMB8rm85
         cfekGsoYqMOortGFa1lIcGxTUQe5pGZVPzF+B1d0p+5SbK/QovnZ9B3BqnR2JN4KtD
         vpz4RkHghz8RkPX5tjrW3ElcYF6oXBpf3FkoZx4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 064/135] net: mdio: Fix ENOMEM return value in BCM6368 mux bus controller
Date:   Tue, 10 May 2022 15:07:26 +0200
Message-Id: <20220510130742.247906403@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

commit e87f66b38e66dffdec9daa9f8f0eb044e9a62e3b upstream.

Error values inside the probe function must be < 0. The ENOMEM return
value has the wrong sign: it is positive instead of negative.
Add a minus sign.

Fixes: e239756717b5 ("net: mdio: Add BCM6368 MDIO mux bus controller")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220428211931.8130-1-dossche.niels@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mdio/mdio-mux-bcm6368.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/mdio/mdio-mux-bcm6368.c
+++ b/drivers/net/mdio/mdio-mux-bcm6368.c
@@ -115,7 +115,7 @@ static int bcm6368_mdiomux_probe(struct
 	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!md->mii_bus) {
 		dev_err(&pdev->dev, "mdiomux bus alloc failed\n");
-		return ENOMEM;
+		return -ENOMEM;
 	}
 
 	bus = md->mii_bus;


