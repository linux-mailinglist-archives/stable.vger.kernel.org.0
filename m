Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6FB3D6018
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhGZPUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237064AbhGZPUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675EA6023D;
        Mon, 26 Jul 2021 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315272;
        bh=iL+6iAJrgQrCuNm1HLPykc9u6iVdMwY36qWMWa2zCQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkjYzww/rdBUGIvMJS7+zwKOrh+SS0EX9bwvIczUotjKhf0Gxp6ydD1Ff3hpKOrAb
         Bc4szK/Lm+cl6VbVKI37iFhxr3PZaJzcqLI4An8DFJTQnf4QMTPGu1Gg9f+VPX066K
         cdBPVjTIoLbIOGigebe4fQjs/OERK60TiDfq9IKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/167] ixgbe: Fix an error handling path in ixgbe_probe()
Date:   Mon, 26 Jul 2021 17:37:17 +0200
Message-Id: <20210726153839.520099834@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit dd2aefcd5e37989ae5f90afdae44bbbf3a2990da ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 6fabd715e6d8 ("ixgbe: Implement PCIe AER support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1bfba87f1ff6..5c8f9ba43968 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11081,6 +11081,7 @@ err_ioremap:
 	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



