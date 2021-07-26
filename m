Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AEB3D601E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbhGZPUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236137AbhGZPUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E94646023D;
        Mon, 26 Jul 2021 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315279;
        bh=M933bod2+0qhpJt1XLY05BpNJ6QBUTHsVSPtkIyYNn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i60s6rnaSK/arCyusxFq4YBpNpgSr+t628WYp1nFhnNeJAJJnvQAg1NCgy+jbK6bt
         kMDOKPus841f/RB0KvJmypKUnJOwkrecWoYrfE5NytLJOczjM/+L2rDvhjEoUb91ls
         66ivhHYso6vpL3WeA4XYFnveBaO8oVNbV8HeJPk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/167] fm10k: Fix an error handling path in fm10k_probe()
Date:   Mon, 26 Jul 2021 17:37:20 +0200
Message-Id: <20210726153839.612706662@linuxfoundation.org>
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
index 9e3103fae723..caedf24c24c1 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -2227,6 +2227,7 @@ err_sw_init:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_netdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



