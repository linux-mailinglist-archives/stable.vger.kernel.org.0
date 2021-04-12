Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57F035CB1B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243380AbhDLQXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243323AbhDLQX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5EBE61353;
        Mon, 12 Apr 2021 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244589;
        bh=apZYOHv4vJ7y+XFZi/DIF8bgJZHsFgODkqsL6C4kF6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGqbe+e+qwSTCnzKXPUSYDzD56hRUnjnEcMVscUlfN4nbiPG2vjknuhppC83ERbzr
         NAvrDZbkQReXCnkpqNjMCPEEUqMfULi+q4S/SCviDoz+fm1vkIZzEWM3n264cw/wG5
         I7KfiE8xMzNEqXa5Duo9GFhJ4zuCuf9nCfID4hvmfl+U9XAFG5fFlpaaRThL19OT2N
         pdlbG206FYwpVNhSFZ0yBUHpf/eviXi+80o63dwest898RApIr6eU27lUyg5bE7Y+h
         yCcniYRhcA5AFDYLJZYJ8/HNNN9mhOrbv930qP0el/GtBjAB6o5tH5xwmupSoe/C/k
         /crDzQ+CXeFBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 10/51] arc: kernel: Return -EFAULT if copy_to_user() fails
Date:   Mon, 12 Apr 2021 12:22:15 -0400
Message-Id: <20210412162256.313524-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit 46e152186cd89d940b26726fff11eb3f4935b45a ]

The copy_to_user() function returns the number of bytes remaining to be
copied, but we want to return -EFAULT if the copy doesn't complete.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/signal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index a78d8f745a67..fdbe06c98895 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -96,7 +96,7 @@ stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 			     sizeof(sf->uc.uc_mcontext.regs.scratch));
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
 
-	return err;
+	return err ? -EFAULT : 0;
 }
 
 static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
@@ -110,7 +110,7 @@ static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
 				&(sf->uc.uc_mcontext.regs.scratch),
 				sizeof(sf->uc.uc_mcontext.regs.scratch));
 	if (err)
-		return err;
+		return -EFAULT;
 
 	set_current_blocked(&set);
 	regs->bta	= uregs.scratch.bta;
-- 
2.30.2

