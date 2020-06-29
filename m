Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAACA20E3A7
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbgF2VQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbgF2SzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CE025567;
        Mon, 29 Jun 2020 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446126;
        bh=cyEEX7langD+kxupY1vGoQ4pXWIJ4cY38zwZzOrtK4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYJoxsbX09+rN3PlT3czUVkjCx3MMS1QyZCQNoa+SznA60NvKSc5DnBGTeovbrDl3
         oYm/jL0k11l5dQBQBpY3EK1zo/JaeaoaZeyEqZbP7sLNIC+sSBXrohXTeVnty7kujZ
         wd0Y5v7S+BnQNrulR8SP91kFshgM6ErVkjMyMtyw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 117/135] net: alx: fix race condition in alx_remove
Date:   Mon, 29 Jun 2020 11:52:51 -0400
Message-Id: <20200629155309.2495516-118-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit e89df5c4322c1bf495f62d74745895b5fd2a4393 ]

There is a race condition exist during termination. The path is
alx_stop and then alx_remove. An alx_schedule_link_check could be called
before alx_stop by interrupt handler and invoke alx_link_check later.
Alx_stop frees the napis, and alx_remove cancels any pending works.
If any of the work is scheduled before termination and invoked before
alx_remove, a null-ptr-deref occurs because both expect alx->napis[i].

This patch fix the race condition by moving cancel_work_sync functions
before alx_free_napis inside alx_stop. Because interrupt handler can call
alx_schedule_link_check again, alx_free_irq is moved before
cancel_work_sync calls too.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/alx/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index df54475d163bf..43bcc19c90680 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -872,8 +872,12 @@ static int __alx_open(struct alx_priv *alx, bool resume)
 
 static void __alx_stop(struct alx_priv *alx)
 {
-	alx_halt(alx);
 	alx_free_irq(alx);
+
+	cancel_work_sync(&alx->link_check_wk);
+	cancel_work_sync(&alx->reset_wk);
+
+	alx_halt(alx);
 	alx_free_rings(alx);
 }
 
@@ -1406,9 +1410,6 @@ static void alx_remove(struct pci_dev *pdev)
 	struct alx_priv *alx = pci_get_drvdata(pdev);
 	struct alx_hw *hw = &alx->hw;
 
-	cancel_work_sync(&alx->link_check_wk);
-	cancel_work_sync(&alx->reset_wk);
-
 	/* restore permanent mac address */
 	alx_set_macaddr(hw, hw->perm_addr);
 
-- 
2.25.1

