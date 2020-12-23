Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583D12E1437
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgLWCWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbgLWCWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 923BB22273;
        Wed, 23 Dec 2020 02:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690151;
        bh=PNzbCRIG/yIP/e2lUq+1swsm+0VlMdlrCzWkPbqYMm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9l7rn/7FAhaQclTuXzIgADJfGy6/ArU20gPU4g9sSflwbqhPOpBP9AupzyM+oyMs
         OlYRCT3vDl6DhZBGIsF8MSg9q1S5p2McERnRUmumkjoqXZgft5Js5gLIS4/FukpInh
         SnrCqti658CX9BczbY6TFuJqu2nQ8G1q/zzbaIzNVjO7uBdtvb3ehQv6RsGcyfIppP
         ACDA/h39zvWlw7tiVptsHfPT1ni9J0phb8COncn5IuTOlhGrXzk0O0g95+qtIIxNDd
         ABCYaz806cxTJFJs0Jsm5eoyZbjsSO6LVIEpYiX+JN4OSIGmyIk1vVMhmz33sqjUda
         5vTOq6yAxOgGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 71/87] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Tue, 22 Dec 2020 21:20:47 -0500
Message-Id: <20201223022103.2792705-71-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index bc089e634a751..26e20b091160a 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -751,7 +751,7 @@ static int vmci_ctx_get_chkpt_doorbells(struct vmci_ctx *context,
 			return VMCI_ERROR_MORE_DATA;
 		}
 
-		dbells = kmalloc(data_size, GFP_ATOMIC);
+		dbells = kzalloc(data_size, GFP_ATOMIC);
 		if (!dbells)
 			return VMCI_ERROR_NO_MEM;
 
-- 
2.27.0

