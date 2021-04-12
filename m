Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E44935CD85
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245252AbhDLQhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343710AbhDLQfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4849E613C9;
        Mon, 12 Apr 2021 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244829;
        bh=q3j0YkazXOCbG2Izf4RL81IikRFJeV8YQYzMLMhbLII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kx3SxsUSMCY6huh/paffoXipMV7DWbMhkqnd03G1PN5dNXccVvlwPF0zutMYbaJcs
         bbuKjDT7lEXfHAAI1Eek1j2dpwLen9bQ+o+7Hl93jKmfqBxNysEfB9Pd2ExkwkcmN1
         9SyrV+0fWnEYzeI5EVyJNXibFPX5cHaxGII9uxdEGji34qJuVyO1zqmeqrYImzhVzX
         L9xq5O7mFkwhSNL+uxYOFC0dXc0vbzicSYKsS8r/8l3+ccULStPaXZlM19AUCcXggB
         3nErc8q/0wXmcnPWdTE2caj09xaCPEhMJfQhB1PBCjj5XGAaNOLTw31vfehkD+vpZU
         FbhV+rdGwFE4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 03/23] arc: kernel: Return -EFAULT if copy_to_user() fails
Date:   Mon, 12 Apr 2021 12:26:44 -0400
Message-Id: <20210412162704.315783-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
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
index d347bbc086fe..16cdb471d3db 100644
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

