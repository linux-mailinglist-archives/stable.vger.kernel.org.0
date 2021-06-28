Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F219B3B630F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhF1Ov2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236462AbhF1OtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B88561D24;
        Mon, 28 Jun 2021 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891017;
        bh=nAqVMz/Q0ieuVcn88c+qsvpkAbdQ8SUFXA9pBZGGx7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjOtGKCtmnCyf7olFo553XLsn6KJbPcJbDOr3lIc1H2fHtNpqIF3c6gWLEmwab6P6
         xkEaNaAxCXOFA6xGyMLr99awl/oFMbIfOO0AfTqKvuxclijIE6orEPsu/LQ/a+NOnH
         UUsR56lFjhKX/RXXB77k2jeFqNqrcWi2mQoYEeCMaIyu3E6ui71aC7ug9hzxq+o9RR
         hgqju84/PhS66qXjELx12z2yK7frHZiM6qt1WPeYrgtgALWdD55B5o03KkkK6TXALj
         ujDHJFtzgvINBYR1/JauGlk9L5bI0h1dbPaBUO8CgiM2Z/JZz6eDM29r+/38SpLGjW
         XMb1Jtp2ed+Uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/88] qlcnic: Fix an error handling path in 'qlcnic_probe()'
Date:   Mon, 28 Jun 2021 10:35:30 -0400
Message-Id: <20210628143628.33342-31-sashal@kernel.org>
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

[ Upstream commit cb3376604a676e0302258b01893911bdd7aa5278 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 451724c821c1 ("qlcnic: aer support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 6684a4cb8b88..45361310eea0 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2711,6 +2711,7 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(ahw);
 
 err_out_free_res:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2

