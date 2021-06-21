Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B46C3AEE86
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhFUQ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232217AbhFUQ20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB91461361;
        Mon, 21 Jun 2021 16:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292614;
        bh=aru5soIzAyaaiihlfzBjkoOBBX4wGyj/7mseXgXu+zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6v6GOEeosoN2C6K4Sb8EcXw73WMpng9b7Nm5pxAJ3fIUnC0vYZRqskO4QrJYhOSg
         4LFbxiDtJSlY5BwpnJVF3SiMsZ2NvhPR2Y0P7hK3GV80/2Qq/Nre21zcj4X80U3jBX
         1f/NXML98gop4dA09j4Bvq8nxnFrGD8eEbOd7/xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/146] be2net: Fix an error handling path in be_probe()
Date:   Mon, 21 Jun 2021 18:14:55 +0200
Message-Id: <20210621154914.865801335@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c19c8c0e666f9259e2fc4d2fa4b9ff8e3b40ee5d ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: d6b6d9877878 ("be2net: use PCIe AER capability")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 676e437d78f6..cb1e1ad652d0 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5905,6 +5905,7 @@ drv_cleanup:
 unmap_bars:
 	be_unmap_pci_bars(adapter);
 free_netdev:
+	pci_disable_pcie_error_reporting(pdev);
 	free_netdev(netdev);
 rel_reg:
 	pci_release_regions(pdev);
-- 
2.30.2



