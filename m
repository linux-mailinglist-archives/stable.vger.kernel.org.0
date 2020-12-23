Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5862E15D4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgLWCyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:54:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbgLWCVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AAC023332;
        Wed, 23 Dec 2020 02:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690028;
        bh=Y3ex+jmEm74ZxolJwUo0+PjH0319uTy3qtsjQ0XSfJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9zje3ziuT7n1Ayafh+cX5mtV2AwFd1OEsfs9IWbpl29YchnEfG83JSYYFTRjpBUN
         bgDqaa7brVIs1LD7iPF9P6cA3Q+xZMW3JztJIZabQTX7b7QTe2ye9hz9Qyj2wBH3Oz
         xVs6806K3RjovPO/O87+OYUpFPA1zCdS9cW5LwWKC5ILseZB75rWlFRqxQtPTbStAB
         txrNqvsWo4zFevhNoSqRLhEYyOHtlzdCIWFNAO2v53LhGb1EFsZ339M+hp9FL89U3f
         6hXdv/WY0cmi6B1Xi+xzPspLPZkXkFerUj4SHSg6AlulVIGK8+Q2HZ+Mf//Zscj2mR
         iqjvzOMrDrxpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 105/130] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Tue, 22 Dec 2020 21:17:48 -0500
Message-Id: <20201223021813.2791612-105-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit 31dcb6c30a26d32650ce134820f27de3c675a45a ]

A kernel-infoleak was reported by syzbot, which was caused because
dbells was left uninitialized.
Using kzalloc() instead of kmalloc() fixes this issue.

Reported-by: syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com
Tested-by: syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Link: https://lore.kernel.org/r/20201122224534.333471-1-anant.thazhemadam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
index 16695366ec926..26ff49fdf0f7d 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -743,7 +743,7 @@ static int vmci_ctx_get_chkpt_doorbells(struct vmci_ctx *context,
 			return VMCI_ERROR_MORE_DATA;
 		}
 
-		dbells = kmalloc(data_size, GFP_ATOMIC);
+		dbells = kzalloc(data_size, GFP_ATOMIC);
 		if (!dbells)
 			return VMCI_ERROR_NO_MEM;
 
-- 
2.27.0

