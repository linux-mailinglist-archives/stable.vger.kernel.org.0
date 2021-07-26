Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4253D5E05
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhGZPFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235871AbhGZPEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 667A260FD8;
        Mon, 26 Jul 2021 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314308;
        bh=FxfbMUKll3T40U36/zRLh5jDZFzW+wMrMIIo5DOULOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ud5qyvzgRlRlDAjQo71QIMYea5Yn2P6T/XEcQILxCg9xeKCE1QE/1HM01ujot6fRr
         jBf67W6J05bsN964VFPeu//k4BUpgpRdUX8jTgK2v5SQ9S9Z+LMquxLuLGQKobEBcV
         u94tfo3OSpkr/Wp2IYHxG3WVWcIzS+enwSMJSaRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 25/60] igb: Fix an error handling path in igb_probe()
Date:   Mon, 26 Jul 2021 17:38:39 +0200
Message-Id: <20210726153825.661043396@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit fea03b1cebd653cd095f2e9a58cfe1c85661c363 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 40a914fa72ab ("igb: Add support for pci-e Advanced Error Reporting")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 9b7ef62ed8fb..38865e9bf934 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2767,6 +2767,7 @@ err_sw_init:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



