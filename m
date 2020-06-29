Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338AF20E78E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391644AbgF2V6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgF2Sf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2502470C;
        Mon, 29 Jun 2020 15:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444046;
        bh=eV4yzH1kV06Q930UvXCrqcVEPU1VE5C1RQqvoOt3gSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVLuYzJMhxR6Dz8rd0avqTRAAQFO0ATSiZ9ze6PqWDqczH4JApIL+xyGd4BAKm+Pn
         ep4EkJhwkmTGb3UfhWuQ7gxCkUG0+9pHk8ky7zhHQh6OJyvC1VQJC4Cr7TKuvbZrsR
         o+3Q8lnSWXnW02Qx9F5LdEJHsnxcDPZzYObFP5C4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 153/265] net: qede: fix use-after-free on recovery and AER handling
Date:   Mon, 29 Jun 2020 11:16:26 -0400
Message-Id: <20200629151818.2493727-154-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit ec6c80590bde6b5dfa4970fffa3572f1acd313ca ]

Set edev->cdev pointer to NULL after calling remove() callback to avoid
using of already freed object.

Fixes: ccc67ef50b90 ("qede: Error recovery process")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 51bb5866a212c..26eb58e7e0765 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1247,6 +1247,7 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	if (system_state == SYSTEM_POWER_OFF)
 		return;
 	qed_ops->common->remove(cdev);
+	edev->cdev = NULL;
 
 	/* Since this can happen out-of-sync with other flows,
 	 * don't release the netdevice until after slowpath stop
-- 
2.25.1

