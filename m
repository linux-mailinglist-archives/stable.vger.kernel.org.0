Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FB535CE65
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244535AbhDLQnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344017AbhDLQge (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F2D6136F;
        Mon, 12 Apr 2021 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244861;
        bh=o0maZVGYgCnzP4OfbpZ1TajAz/ChKWpbamAKFME+umo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRxMHB8EQGgMJGbbz1q47w7AOYE5LHIClkZW4V6qHz/bB55O6OvL0/JmUARcgcPwz
         TjZQzs91zhwTWloG5scRy6L7oF4JxmA0hYCTiTa4QOcjcdrxkKgYTgcZmSGG46/uwK
         Jlby5O4yaPv+rp+UBxwXh9M3C5xTjZ594O8fwAR3q9gRwGXW1CqXjWkXQKzx5sXlf0
         7srFg+C1ZUKCUKOFHRJ2n9XYsrMEew8hidk82jro0udESydp5IYGXlh8HHBebHthk4
         a/oyOkTp99ULQDIpwmzXS+9rZPr+2+UagC/ojnBHHSNzziAKnXMnWwaMyAZHYwj7C0
         GW9WSSrFFT0YQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 03/23] arc: kernel: Return -EFAULT if copy_to_user() fails
Date:   Mon, 12 Apr 2021 12:27:16 -0400
Message-Id: <20210412162736.316026-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
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
index 257b8699efde..639f39f39917 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -97,7 +97,7 @@ stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 			     sizeof(sf->uc.uc_mcontext.regs.scratch));
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
 
-	return err;
+	return err ? -EFAULT : 0;
 }
 
 static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
@@ -111,7 +111,7 @@ static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
 				&(sf->uc.uc_mcontext.regs.scratch),
 				sizeof(sf->uc.uc_mcontext.regs.scratch));
 	if (err)
-		return err;
+		return -EFAULT;
 
 	set_current_blocked(&set);
 	regs->bta	= uregs.scratch.bta;
-- 
2.30.2

