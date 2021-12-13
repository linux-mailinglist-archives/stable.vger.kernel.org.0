Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C104728F0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbhLMKQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243792AbhLMKOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:14:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B76C08ED7A;
        Mon, 13 Dec 2021 01:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 301A0CE0E7D;
        Mon, 13 Dec 2021 09:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC268C34602;
        Mon, 13 Dec 2021 09:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389304;
        bh=hCZYLQSYCT8hOZ3Xz14J4RwOHlcJeC+j3s0L/lPGTPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zprT8oydQoX248ZtNqQIuCvsF3bSkiADV7FpTgGfCazK626EjkR/C1XN51mNu90ZU
         ThImef8ROQT3+m/Hh+37Z3FUITI60EDTd+6IBxDGQ8qYtuDsqIohKabe+9YxmpN7Zo
         9DMoP0bRvTgtRNMDw7cL1BoKWmKtkcxCv6/NO2B8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 052/171] net: bcm4908: Handle dma_set_coherent_mask error codes
Date:   Mon, 13 Dec 2021 10:29:27 +0100
Message-Id: <20211213092946.837914536@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit 128f6ec95a282b2d8bc1041e59bf65810703fa44 upstream.

The return value of dma_set_coherent_mask() is not always 0.
To catch the exception in case that dma is not support the mask.

Fixes: 9d61d138ab30 ("net: broadcom: rename BCM4908 driver & update DT binding")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -708,7 +708,9 @@ static int bcm4908_enet_probe(struct pla
 
 	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
 
-	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	err = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
 
 	err = bcm4908_enet_dma_alloc(enet);
 	if (err)


