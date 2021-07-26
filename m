Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF69E3D5F08
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbhGZPQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236359AbhGZPK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37F7D60F38;
        Mon, 26 Jul 2021 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314687;
        bh=9xvJbSxFcs+saNW7ls9ETJJVSe9d7yJ5GMuRQ0aoegA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10BIM6sJdANISEpPAZGbCbkvoPWL+38MExemiPwypSfyQdpY1d21TqXW1jOo0fBYE
         HMRk325UFkxMC5Xp67C4g1VtH2rXEIEm4xdq60xv6sSGiwZ2XdBlMfwW9D7g0UqDCQ
         GnfDmvwyzEaqs229dpwb55aHgK7tSSC2cJpj2J8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/120] fm10k: Fix an error handling path in fm10k_probe()
Date:   Mon, 26 Jul 2021 17:38:28 +0200
Message-Id: <20210726153834.178831055@linuxfoundation.org>
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

[ Upstream commit e85e14d68f517ef12a5fb8123fff65526b35b6cd ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 19ae1b3fb99c ("fm10k: Add support for PCI power management and error handling")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index c859ababeed5..6e888874010e 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -2228,6 +2228,7 @@ err_sw_init:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_netdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



