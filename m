Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAF92E13D0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgLWCfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbgLWCYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD7622248;
        Wed, 23 Dec 2020 02:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690240;
        bh=PNzbCRIG/yIP/e2lUq+1swsm+0VlMdlrCzWkPbqYMm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jf1vAYcLjGruDupLh4it9yUHSMFfMwcZddeRqJF9k1P8nzlhDb41YKUoGYOcf5BgY
         YbMVbKcEcLVczhYQ+fx4UbT4ISuOTSwspzNnYmXZmcVxmeOjFo31pTgD7L1S5qfKpH
         ucea9HPgAunuyYu25Y4s+MPc9NIHSurfoUoRSsu5gbvylceGji9VXyeqKMF6HbAln6
         WEcPL+TBd7+MOWeUIMpDC0zNcSlDxtvX3bLls+35gSFujoRk6fi4N9SS8AaLpSobeg
         Nvjhye7TPLDMpEKt0DpnfCoEt8LMEqGl7vDYNhKw/xTXV8pHnX8XWXiHbRZ6Jy6BqL
         FKhXmo1FWdepw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 54/66] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Tue, 22 Dec 2020 21:22:40 -0500
Message-Id: <20201223022253.2793452-54-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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

