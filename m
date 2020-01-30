Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1222A14E120
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgA3Sle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:41:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbgA3Sla (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBA86215A4;
        Thu, 30 Jan 2020 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409690;
        bh=Wha8RaYeuye8yMvMNocTallzMzxYbMMpXjBjFv1Fxyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7gqO5bWij5+S7zxejrjOzthG0CDn1uEEhHGyNaHQ/owbjDf4DGaL0MIGP4/5HG09
         HohOIP0ydce6l+R0E6EDlG1RHNPMoivY9sKbnOpoROgmBjFRTFugDYr0bU3Zi4VC33
         7zyv+fF2qvPMpSiREpDKFP6yNDvNc7TUBTiYWL0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iuliana Prodan <iuliana.prodan@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Alison Wang <alison.wang@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 52/56] crypto: caam - do not reset pointer size from MCFGR register
Date:   Thu, 30 Jan 2020 19:39:09 +0100
Message-Id: <20200130183618.226576789@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

commit 7278fa25aa0ebcc0e62c39b12071069df13f7e77 upstream.

In commit 'a1cf573ee95 ("crypto: caam - select DMA address size at runtime")'
CAAM pointer size (caam_ptr_size) is changed from
sizeof(dma_addr_t) to runtime value computed from MCFGR register.
Therefore, do not reset MCFGR[PS].

Fixes: a1cf573ee95 ("crypto: caam - select DMA address size at runtime")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: <stable@vger.kernel.org>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Alison Wang <alison.wang@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/ctrl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -671,11 +671,9 @@ static int caam_probe(struct platform_de
 	of_node_put(np);
 
 	if (!ctrlpriv->mc_en)
-		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK | MCFGR_LONG_PTR,
+		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK,
 			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |
-			      MCFGR_WDENABLE | MCFGR_LARGE_BURST |
-			      (sizeof(dma_addr_t) == sizeof(u64) ?
-			       MCFGR_LONG_PTR : 0));
+			      MCFGR_WDENABLE | MCFGR_LARGE_BURST);
 
 	handle_imx6_err005766(&ctrl->mcr);
 


