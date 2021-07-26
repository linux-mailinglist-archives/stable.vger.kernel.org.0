Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C23D601C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhGZPUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237073AbhGZPUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D72B60230;
        Mon, 26 Jul 2021 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315276;
        bh=mEYG4fvcnGPSjKjp6IbyUK0XvSK+0+7wUJ7nmnNgqyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlE1c2JqaPScXBrvKFko5wa5mjQ/Ekaoz2FX5MgiPndiHpksV9as6fFvzRsqpE58e
         pbNmJiluMjgv2dWmpWhBaXY3OMdM12DLJJu3G9KGV4VIGOmozojfbeengByvNJBIEZ
         CXdlB3Z810eCRMzI+0w3uGg9rGGLd1RWWgz9I2Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/167] igb: Fix an error handling path in igb_probe()
Date:   Mon, 26 Jul 2021 17:37:19 +0200
Message-Id: <20210726153839.581310742@linuxfoundation.org>
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
index b40654664025..43f2096a0669 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3616,6 +3616,7 @@ err_sw_init:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



