Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2233AED79
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhFUQUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhFUQUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAD5B61206;
        Mon, 21 Jun 2021 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292265;
        bh=pmEHXmeHLRuARTxAe3cAJWpj9+zGJ4hdCv3cu+vSC2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THf4WhxzneLzDAYj3AeVo5kegFPaeXIFYWWA3XXbmsoD+ZNq1i6kK8Dgu78uyt2Pq
         y9aVos/0KyZZjOMLCNY8YAmtsB0cMMYVMBKn+leLXFK2vXNMqCceQ+bfejWF2xqCzP
         jV9pVCgG5dv1SQCcwvWcujoD22D45NC5c3gLNBOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/90] netxen_nic: Fix an error handling path in netxen_nic_probe()
Date:   Mon, 21 Jun 2021 18:15:01 +0200
Message-Id: <20210621154905.008089860@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 49a10c7b176295f8fafb338911cf028e97f65f4d ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: e87ad5539343 ("netxen: support pci error handlers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 25b6f2ee2beb..1b9867ea4333 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1602,6 +1602,8 @@ err_out_free_netdev:
 	free_netdev(netdev);
 
 err_out_free_res:
+	if (NX_IS_REVISION_P3(pdev->revision))
+		pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2



