Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C972E1327
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgLWC2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730808AbgLWC0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:26:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 584C4225AB;
        Wed, 23 Dec 2020 02:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690357;
        bh=TFGy+LQiUGgRTyrcomJE+0sOywuluX9VF45YyfZGh7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHBaInAvUBhbFiTackzYQYzkWpZlM10cSXweFsXU/19ZdblFnMD22v28dSAzdOc1H
         rU0G+sV6YP+ZTvBJrM41OH0EZrwv0Hs9mwGVnNjNp1LY+XDkTlAiZjkcZmB9In5xFO
         BtYLNGHNGbaIirJoE3uy5iJ53m7REmcHEUXan1js9snG+/A+pM0wjlRZSMhe4hJfb1
         Eshw3C3+zdjP5w+NW492WuXx6WrTSgIQ6MBgSWlh1Hi//tLZdteqQNaQMw0OEU3Bjq
         xuZcPlmlx+/V2MovIOSVVf7/+C17wgfQry0hH2JYA+OfeJ+vhLuWH3vrVDJdExwjhY
         NHZdvuzfTu8GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+a79e17c39564bedf0930@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 32/38] misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()
Date:   Tue, 22 Dec 2020 21:25:10 -0500
Message-Id: <20201223022516.2794471-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
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

