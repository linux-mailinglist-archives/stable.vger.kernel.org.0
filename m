Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E71D8269
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbgERR4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729921AbgERR4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B35F207C4;
        Mon, 18 May 2020 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824575;
        bh=vjM1O94rgx2tx7HK6gBqTpJ9GjaQq+alA5IdlOKPtJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJ2MDBRBIrXhFf4tiOEtpC9Of6tmfCYP7QaNGWP0I/FEt7wGhtO9ljO7fLqEmOrRJ
         sHKxHvdpkaXeraj0x4wGxx4k2wMpz4kbxAiXv9yaJ/EKO10pEZWfYBWapTsXraygVJ
         BPq/AAoxaiOt1c5nJGazlVnXIQ4gqdMUIMzJJ1iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/147] dmaengine: mmp_tdma: Do not ignore slave config validation errors
Date:   Mon, 18 May 2020 19:36:02 +0200
Message-Id: <20200518173518.945704430@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 363c32701c7fdc8265a84b21a6a4f45d1202b9ca ]

With an invalid dma_slave_config set previously,
mmp_tdma_prep_dma_cyclic() would detect an error whilst configuring the
channel, but proceed happily on:

  [  120.756530] mmp-tdma d42a0800.adma: mmp_tdma: unknown burst size.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://lore.kernel.org/r/20200419164912.670973-2-lkundrak@v3.sk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_tdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index e7d1e12bf4643..4d5b987e4841a 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -443,7 +443,8 @@ static struct dma_async_tx_descriptor *mmp_tdma_prep_dma_cyclic(
 	if (!desc)
 		goto err_out;
 
-	mmp_tdma_config_write(chan, direction, &tdmac->slave_config);
+	if (mmp_tdma_config_write(chan, direction, &tdmac->slave_config))
+		goto err_out;
 
 	while (buf < buf_len) {
 		desc = &tdmac->desc_arr[i];
-- 
2.20.1



