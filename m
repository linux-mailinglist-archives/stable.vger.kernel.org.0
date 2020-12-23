Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FAF2E13A3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgLWCcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbgLWCZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E93C23159;
        Wed, 23 Dec 2020 02:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690303;
        bh=TFGy+LQiUGgRTyrcomJE+0sOywuluX9VF45YyfZGh7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TR5PDbG5OYOiZBUiQVstA/wj6WF1lMJ8ZzFTFTJZp5YYonVbCppHySjWWtrfXrN3c
         JQ4OF9V3Dvbktba4M75Ov3s+JnSuUkOxW7ynE9kHSj1O8X69Av7Cuvs8EMFO2CG6AG
         R7p1kznlprIqki8lBkOguDgBRochh1tABugrweKSXPyjuPxkqscNIABHLR6dyLV97d
         7Ggp7NekusaCRF2RTSnussceN3kvodqzgPKEJitvrsGbUva6OKr3+r9FiQunTdJnAE
         oWW5M4u9CrJsVZ/pkKzgO88A8W4QWDNUSOuXdvboFaq/tfP5UA7X92emmnMxk+4XFQ
         VCn4Zw/gs8I2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 38/48] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Tue, 22 Dec 2020 21:24:06 -0500
Message-Id: <20201223022417.2794032-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index b9da2c6cc9818..0bdfa90ea6cda 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -750,7 +750,7 @@ static int vmci_ctx_get_chkpt_doorbells(struct vmci_ctx *context,
 			return VMCI_ERROR_MORE_DATA;
 		}
 
-		dbells = kmalloc(data_size, GFP_ATOMIC);
+		dbells = kzalloc(data_size, GFP_ATOMIC);
 		if (!dbells)
 			return VMCI_ERROR_NO_MEM;
 
-- 
2.27.0

