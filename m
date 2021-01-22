Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9747C300C47
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbhAVSnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbhAVOWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CB3323ACA;
        Fri, 22 Jan 2021 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324976;
        bh=T1i6jgrBUKTaP3yAda/qISxZv6nd9DUKl2JCwHSKDfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Yb7jYlIH/H5k/+Q9gLobLdff2pIRYuEAieTftdwpCVlH4ewXww5gfNH1Lp0j8jkH
         +DFwSJYnIonIEGhzcVQ0AlVLYlXAsN1fdGCYi4d1L7sh3nzGKvw352K3NOUGub3FIs
         hSAztH3e1tQd6DkqGt7P3LJ473MpbVB3Img4atp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 07/22] netxen_nic: fix MSI/MSI-x interrupts
Date:   Fri, 22 Jan 2021 15:12:25 +0100
Message-Id: <20210122135732.211512850@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit a2bc221b972db91e4be1970e776e98f16aa87904 ]

For all PCI functions on the netxen_nic adapter, interrupt
mode (INTx or MSI) configuration is dependent on what has
been configured by the PCI function zero in the shared
interrupt register, as these adapters do not support mixed
mode interrupts among the functions of a given adapter.

Logic for setting MSI/MSI-x interrupt mode in the shared interrupt
register based on PCI function id zero check is not appropriate for
all family of netxen adapters, as for some of the netxen family
adapters PCI function zero is not really meant to be probed/loaded
in the host but rather just act as a management function on the device,
which caused all the other PCI functions on the adapter to always use
legacy interrupt (INTx) mode instead of choosing MSI/MSI-x interrupt mode.

This patch replaces that check with port number so that for all
type of adapters driver attempts for MSI/MSI-x interrupt modes.

Fixes: b37eb210c076 ("netxen_nic: Avoid mixed mode interrupts")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Link: https://lore.kernel.org/r/20210107101520.6735-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -580,11 +580,6 @@ static const struct net_device_ops netxe
 	.ndo_set_features = netxen_set_features,
 };
 
-static inline bool netxen_function_zero(struct pci_dev *pdev)
-{
-	return (PCI_FUNC(pdev->devfn) == 0) ? true : false;
-}
-
 static inline void netxen_set_interrupt_mode(struct netxen_adapter *adapter,
 					     u32 mode)
 {
@@ -680,7 +675,7 @@ static int netxen_setup_intr(struct netx
 	netxen_initialize_interrupt_registers(adapter);
 	netxen_set_msix_bit(pdev, 0);
 
-	if (netxen_function_zero(pdev)) {
+	if (adapter->portnum == 0) {
 		if (!netxen_setup_msi_interrupts(adapter, num_msix))
 			netxen_set_interrupt_mode(adapter, NETXEN_MSI_MODE);
 		else


