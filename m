Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751F8491C2D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348993AbiARDOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349978AbiARDHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:07:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0379C014F3A;
        Mon, 17 Jan 2022 18:49:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA7661346;
        Tue, 18 Jan 2022 02:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934FFC36AEB;
        Tue, 18 Jan 2022 02:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474146;
        bh=1rb8EM3XDFWr+VyTcb3Rfus7JTqCNfeY0zVb9E/f6mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrngtD43YPpYmMJGaEC1twLsU/d+8UVxwnGeQKsNZloWDZzDP0+TA+q3lU1F7HqEq
         dHybt9vP/gwSu6tsPACJR5wQIkZJV93xrE7MI+PygnfgBAcyskt+0T5DnfCM7ejKCN
         lVzELCR5ZT3tQ6sH+Ectgqyg1fAzYkrFwpOVFiSW8FM6vx1u2nlGCh2r4DnD6V0Mi9
         y7JM5sbX5oEan0A+FkvWXO4M+kJ0pFRYbElAPspziQRuvShWkx2mXfvTuLcvEAveAk
         90uM3YGK9bw0BcL+oR69a9TyK8WNNWEULBYRlH/8E/GJcWT7qMN8kp4RGUP0Yh268J
         O3AzYs36GDkqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        rmk+kernel@armlinux.org.uk, mpe@ellerman.id.au,
        akpm@linux-foundation.org, wangkefeng.wang@huawei.com,
        ebiederm@xmission.com, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 59/59] parisc: Avoid calling faulthandler_disabled() twice
Date:   Mon, 17 Jan 2022 21:47:00 -0500
Message-Id: <20220118024701.1952911-59-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit 9e9d4b460f23bab61672eae397417d03917d116c ]

In handle_interruption(), we call faulthandler_disabled() to check whether the
fault handler is not disabled. If the fault handler is disabled, we immediately
call do_page_fault(). It then calls faulthandler_disabled(). If disabled,
do_page_fault() attempts to fixup the exception by jumping to no_context:

no_context:

        if (!user_mode(regs) && fixup_exception(regs)) {
                return;
        }

        parisc_terminate("Bad Address (null pointer deref?)", regs, code, address);

Apart from the error messages, the two blocks of code perform the same
function.

We can avoid two calls to faulthandler_disabled() by a simple revision
to the code in handle_interruption().

Note: I didn't try to fix the formatting of this code block.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index abeb5321a83fc..d7a66d8525091 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -750,7 +750,7 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0 && !faulthandler_disabled())
+	    if (faulthandler_disabled() || fault_space == 0)
 	    {
 		/* Clean up and return if in exception table. */
 		if (fixup_exception(regs))
-- 
2.34.1

