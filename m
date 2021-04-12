Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E618035CBB5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243667AbhDLQZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243704AbhDLQYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A4961350;
        Mon, 12 Apr 2021 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244653;
        bh=dacTTHiBg9ZOIvv+f+gvb9A+CQQYT6YWtqr5Sk2uCD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMKELo7w8MB0asBALPoO567lQBWPldKpEh3lR2ecnjL0sx6pgVPicyNE6GH85y+g9
         pIqhuYKvN596Uj27hjDXLmSqGkKUw2LCGnbc9gw+2lz5bxrRdSj7y0LbHQ/dycj3EE
         XMvLhog+QK1ygLHYnqbWHHpSRMAMtJeOEAaZGgSnQjqCj+C3PqILkEImoAVIWvjvO2
         N3ooU9/c6W+IUcPtpfJKQOscpYR235IM8rla9roZH4cweWQijmvbtIT7j3Z6kowaJC
         z02mAsmMpR/mlUm616y4GZtXSpyJUiumzfXZT/7H3zat7xzobS4D88hcYim1t2ySEd
         6hZDs3h82b0JA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 09/46] arc: kernel: Return -EFAULT if copy_to_user() fails
Date:   Mon, 12 Apr 2021 12:23:24 -0400
Message-Id: <20210412162401.314035-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
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
index 2be55fb96d87..98e575dbcce5 100644
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

