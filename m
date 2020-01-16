Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2614000A
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732782AbgAPXrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390727AbgAPXUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9492072B;
        Thu, 16 Jan 2020 23:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216848;
        bh=98cRC04yURKjGE1BkLFvLk6G387leR2Q90ANMDBQl5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQsWHzJXt1rHLoRYLKrv2DJ8E/lfKwqoLx4oI+ND/6YkW1Wufue5FlG84LY03belr
         eQfBEMuuDNAqVds23W8x1PolB0qhtGYhlKRihH0mi1MvPMZoP2AH/7WkWS6rbTyMoX
         RSDGQDG3FIJvVLe86GhCLguI+pU2tIzPrL50bzIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.4 044/203] reset: brcmstb: Remove resource checks
Date:   Fri, 17 Jan 2020 00:16:01 +0100
Message-Id: <20200116231747.854191375@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit ce89d8d3a70fa530e16f0b0f8994385a214cd0c0 upstream.

The use of IS_ALIGNED() is incorrect, the typical resource we pass looks
like this: start: 0x8404318, size: 0x30. When using IS_ALIGNED() we will
get the following 0x8404318 & (0x18 - 1) = 0x10 which is definitively
not equal to 0, same goes with the size. These two checks would make the
driver fail probing.

Remove the resource checks, since there should be no constraint on the
base addresse or size.

Fixes: 77750bc089e4 ("reset: Add Broadcom STB SW_INIT reset controller driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/reset/reset-brcmstb.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/reset/reset-brcmstb.c
+++ b/drivers/reset/reset-brcmstb.c
@@ -91,12 +91,6 @@ static int brcmstb_reset_probe(struct pl
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!IS_ALIGNED(res->start, SW_INIT_BANK_SIZE) ||
-	    !IS_ALIGNED(resource_size(res), SW_INIT_BANK_SIZE)) {
-		dev_err(kdev, "incorrect register range\n");
-		return -EINVAL;
-	}
-
 	priv->base = devm_ioremap_resource(kdev, res);
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);


