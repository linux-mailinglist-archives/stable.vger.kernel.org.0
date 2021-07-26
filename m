Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D903D5F1E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhGZPQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236360AbhGZPLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F776056C;
        Mon, 26 Jul 2021 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314693;
        bh=va88ssUqXsASXfCuORxhTvQJYOdmng6FTcfoFTz0ALY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAYfeI+k1kBHnNXRnEvCol6jTJUAoU1ZY9vv5q5JbRSl+bHXAa7Cx+cAuXuzWPBnn
         jdj2v7tdujUfQdc1lHqtQj3v6NZFHvxP0PvMLBA3xr5LpzpiC4/IXc8PgWG9syfbv5
         4iAB+uVA4dgQk0U1Jj3EoU/QmPgdJsRN77Ta7JSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/120] e1000e: Fix an error handling path in e1000_probe()
Date:   Mon, 26 Jul 2021 17:38:29 +0200
Message-Id: <20210726153834.210350335@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4589075608420bc49fcef6e98279324bf2bb91ae ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 111b9dc5c981 ("e1000e: add aer support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6bbe7afdf30c..398f5951d11c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7369,6 +7369,7 @@ err_flashmap:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



