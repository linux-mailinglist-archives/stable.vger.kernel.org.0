Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D786032909F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbhCAULm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241430AbhCAUCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:02:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BFCE65391;
        Mon,  1 Mar 2021 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621455;
        bh=ti2nkFNhuDh1GQ9wFtzWqM+BIk4OE9m+OR3PDoFkwnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onpMsDvLEVUt5oPjrdyVzYSJ9SJkZFebFKcUBx2auMVOTfPGLRg0kjpcgLHeVZikl
         w+ZNu8fdHJUJ1lSI3iZ5etU/jQ9++jiFCcQjZpjUPfuEfQstIBBoKCdmhszCc7pfyM
         OPMlZaSkxLJ3YCvxaLt4rrANNc2avzeHtMcpmtm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 522/775] PCI: cadence: Fix DMA range mapping early return error
Date:   Mon,  1 Mar 2021 17:11:30 +0100
Message-Id: <20210301161227.319341429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczyński <kw@linux.com>

[ Upstream commit 1002573ee33efef0988a9a546c075a9fa37d2498 ]

Function cdns_pcie_host_map_dma_ranges() iterates over a PCIe host bridge
DMA ranges using the resource_list_for_each_entry() iterator, returning an
error if cdns_pcie_host_bar_config() fails.

49e427e6bdd1 ("Merge branch 'pci/host-probe-refactor'") botched a merge so
it *always* returned after the first DMA range, even if no error occurred.

Fix the error checking so we return early only when an error occurs.

[bhelgaas: commit log]
Fixes: 49e427e6bdd1 ("Merge branch 'pci/host-probe-refactor'")
Link: https://lore.kernel.org/r/20210216205935.3112661-1-kw@linux.com
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-host.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index 811c1cb2e8deb..1cb7cfc75d6e4 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -321,9 +321,10 @@ static int cdns_pcie_host_map_dma_ranges(struct cdns_pcie_rc *rc)
 
 	resource_list_for_each_entry(entry, &bridge->dma_ranges) {
 		err = cdns_pcie_host_bar_config(rc, entry);
-		if (err)
+		if (err) {
 			dev_err(dev, "Fail to configure IB using dma-ranges\n");
-		return err;
+			return err;
+		}
 	}
 
 	return 0;
-- 
2.27.0



