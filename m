Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121EA12C849
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbfL2RxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731915AbfL2RxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F249206DB;
        Sun, 29 Dec 2019 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641985;
        bh=wZR43cdOZ840SUYOIMS563I9ps+OO9HbW5nDxOQehc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbV3dNNeHjLnvDRnkWplorYOVK4kdQpNZt/0LiDi9gLypPIrKmcNGx9yFIOvjNAUM
         363MIDDRQz+8Ph88Xbc5vP/QtSNtp5BFLQ5HPHZeI6S9rZpQ0DaNbUl46yFO5rBYoV
         g9Qdx2Wsxzq/9GDoHvoQcjzoot2BTR0s94cl5amk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 295/434] net: ethernet: ti: Add dependency for TI_DAVINCI_EMAC
Date:   Sun, 29 Dec 2019 18:25:48 +0100
Message-Id: <20191229172721.543220645@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit b2ef81dcdf3835bd55e5f97ff30131bb327be7fa ]

If TI_DAVINCI_EMAC=y and GENERIC_ALLOCATOR is not set,
below erros can be seen:
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_desc_pool_destroy.isra.14':
davinci_cpdma.c:(.text+0x359): undefined reference to `gen_pool_size'
davinci_cpdma.c:(.text+0x365): undefined reference to `gen_pool_avail'
davinci_cpdma.c:(.text+0x373): undefined reference to `gen_pool_avail'
davinci_cpdma.c:(.text+0x37f): undefined reference to `gen_pool_size'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `__cpdma_chan_free':
davinci_cpdma.c:(.text+0x4a2): undefined reference to `gen_pool_free_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_chan_submit_si':
davinci_cpdma.c:(.text+0x66c): undefined reference to `gen_pool_alloc_algo_owner'
davinci_cpdma.c:(.text+0x805): undefined reference to `gen_pool_free_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_ctlr_create':
davinci_cpdma.c:(.text+0xabd): undefined reference to `devm_gen_pool_create'
davinci_cpdma.c:(.text+0xb79): undefined reference to `gen_pool_add_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_check_free_tx_desc':
davinci_cpdma.c:(.text+0x16c6): undefined reference to `gen_pool_avail'

This patch mades TI_DAVINCI_EMAC select GENERIC_ALLOCATOR.

Fixes: 99f629718272 ("net: ethernet: ti: cpsw: drop TI_DAVINCI_CPDMA config option")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 834afca3a019..137632b09c72 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -22,6 +22,7 @@ config TI_DAVINCI_EMAC
 	depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 ) || COMPILE_TEST
 	select TI_DAVINCI_MDIO
 	select PHYLIB
+	select GENERIC_ALLOCATOR
 	---help---
 	  This driver supports TI's DaVinci Ethernet .
 
-- 
2.20.1



