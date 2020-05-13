Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE481D0D80
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387976AbgEMJxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387972AbgEMJxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C751C205ED;
        Wed, 13 May 2020 09:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363614;
        bh=3RblSuSHb5U89WwAV59h/TSflXzIDVmXUYRrc3Iy2ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwHO9y/kUno75JX5SjIW4gJGjhwOVsZT2Yqwrp3HojWQecxzIAfSXDiiTvMUqVmyS
         TQ+ZQIDBK7iqy64asIsrHTkwyuNm7g1bzBfdOIGqlUAYpxDlTer7D31d+LgUMmDSWk
         V1u0G7SQYBMPZu6Ol/ew4lKnKw5IkdAMyfdNbC4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 054/118] net: enetc: fix an issue about leak system resources
Date:   Wed, 13 May 2020 11:44:33 +0200
Message-Id: <20200513094421.808935767@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit d975cb7ea915e64a3ebcfef8a33051f3e6bf22a8 ]

the related system resources were not released when enetc_hw_alloc()
return error in the enetc_pci_mdio_probe(), add iounmap() for error
handling label "err_hw_alloc" to fix it.

Fixes: 6517798dd3432a ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
@@ -74,8 +74,8 @@ err_pci_mem_reg:
 	pci_disable_device(pdev);
 err_pci_enable:
 err_mdiobus_alloc:
-	iounmap(port_regs);
 err_hw_alloc:
+	iounmap(port_regs);
 err_ioremap:
 	return err;
 }


