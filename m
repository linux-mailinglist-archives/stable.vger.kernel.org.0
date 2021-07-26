Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F473D5D47
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhGZPA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235283AbhGZPA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0421E60F58;
        Mon, 26 Jul 2021 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314057;
        bh=0tWEQcgP/NxYyZbe52ECZGUkTm5tV7hfOy4ey7x4VgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ou6Ts111LnbsV1NO/viiuKZWQBx7021fghT+US6G0QHv+nkQmLoNRtuRuP2GVxqb3
         F6uF+VcNEbWYPy0v4feXop2TP5DXNuMkK340sCG4kVN00GxBF9wEA1Hvcs8HdV839X
         o8qPgidMLauig3pu4AhyC4lcxHd28f0VGs504ma8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/47] iavf: Fix an error handling path in iavf_probe()
Date:   Mon, 26 Jul 2021 17:38:36 +0200
Message-Id: <20210726153823.555238037@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit af30cbd2f4d6d66a9b6094e0aa32420bc8b20e08 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 5eae00c57f5e ("i40evf: main driver core")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index 5f03ab3dfa19..8fdbc24b3cba 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -2503,6 +2503,7 @@ static int i40evf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.30.2



