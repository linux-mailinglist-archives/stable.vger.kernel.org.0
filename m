Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F943D6152
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhGZPam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237703AbhGZP3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9337860C41;
        Mon, 26 Jul 2021 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315699;
        bh=IcyHKxIoELY5UU2oTvwgAu2yK7y4njzTJbLhRAreMhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/mWwtkptkABPRwgVMJ3ksfTRQbKuo0Z93niEdsn8o1G+4m7F1vEMLY34BVgKDIhp
         gZ/8bQBuEldztgptBeBRkCqO9HtOjIxrbCR0HuAVeVqpOBx9XMQuTTikePQVY8SASv
         8nOh8BLJ5cVOSFyDfIiGFIV3+f3OTuRkkvrC3mWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 005/223] igc: Fix an error handling path in igc_probe()
Date:   Mon, 26 Jul 2021 17:36:37 +0200
Message-Id: <20210726153846.429480830@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c6bc9e5ce5d37cb3e6b552f41b92a193db1806ab ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: c9a11c23ceb6 ("igc: Add netdev")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9cac1e74a2ba..a8d5f196fdbd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5596,6 +5596,7 @@ err_sw_init:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



