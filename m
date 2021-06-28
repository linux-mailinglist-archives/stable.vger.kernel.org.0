Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B033B6310
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhF1Ov3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236460AbhF1OtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153DD61D1F;
        Mon, 28 Jun 2021 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891015;
        bh=Bx6wtprcLfqR0Qdk11ebcb+1KV7bus5+2g5xRipo7Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pU6XlyK0/3pDmI0yC9/bRBnyBcOE07VlfgsuLivjYLjrfHFX6e66IgPNIr2dxcGx/
         yctYNDp+2tQGxtGtxgZHZe9btTpzWAl8dHS+dzJuCSjvm8ST/Q7nAz3jxlN1yaWN8X
         hZOkNJBXSfh9Dv0TywDqDZ80njKhPngXJjlTRGIRrChdjL1nxxXwfkk5wO2kBs8Sul
         ixcXCjDjDVHXX7tV4NwAE7Z4HGRwVvRpc2hAKFV72XvQix6lrXBwIB8cGbpZWt7ZIr
         2Dvw2NsIWEkSlGmCy2EOZe1lHV+jSvrpv8YDQkB4IXpBQE34baQ7qh5WBYnz1D1CwI
         Z8BJmV24k0Jqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/88] alx: Fix an error handling path in 'alx_probe()'
Date:   Mon, 28 Jun 2021 10:35:28 -0400
Message-Id: <20210628143628.33342-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 33e381448cf7a05d76ac0b47d4a6531ecd0e5c53 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: ab69bde6b2e9 ("alx: add a simple AR816x/AR817x device driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/alx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index ce2e64410823..bb0e217460c9 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1857,6 +1857,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 out_pci_release:
 	pci_release_mem_regions(pdev);
+	pci_disable_pcie_error_reporting(pdev);
 out_pci_disable:
 	pci_disable_device(pdev);
 	return err;
-- 
2.30.2

