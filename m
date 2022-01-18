Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F89F491A70
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352357AbiARC7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41378 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344281AbiARCsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:48:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ABB76093C;
        Tue, 18 Jan 2022 02:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CDAC36AE3;
        Tue, 18 Jan 2022 02:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474081;
        bh=2Ao0xJWtEm824Wm0cz0zDXdrq9k9TSs5nYnz5dAhi+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgOnPQPcbj4JdVhsJzcAih7lG6kBuu7fX844KinlFWb8uPNAj5YADAZLWhzneLTwl
         bYyWX3pyhdwcvE2h1B4lG/iVSAj4wNRfKLng3yBrUWR5z0Y4gUmgy3lJiCaHLm1UlI
         gW9at/cT6URGriLek5s5TCjaj3cyx9kHmxW5D61DoJgUanROZe3e6RR1fv5G5JRc/I
         WH981Rr4lcuL/gELAU704Eyy5vo4SICx2TMpOQ7cC/Ijy/QT1YIQpkt3KjYxw5v3/Z
         03mYbKrL4wN7m7b8dx0wp3ITDPsv7D1VDcNWm5X77ACyCn5UeA0GJfAmtEvImn6Dc3
         M4ZFDU2cN6uSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Subject: [PATCH AUTOSEL 4.19 26/59] x86/mce: Mark mce_read_aux() noinstr
Date:   Mon, 17 Jan 2022 21:46:27 -0500
Message-Id: <20220118024701.1952911-26-sashal@kernel.org>
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

From: Borislav Petkov <bp@suse.de>

[ Upstream commit db6c996d6ce45dfb44891f0824a65ecec216f47a ]

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0x681: call to mce_read_aux() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-10-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 26adaad3f2587..8f36ccf26ceca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -651,7 +651,7 @@ static struct notifier_block mce_default_nb = {
 /*
  * Read ADDR and MISC registers.
  */
-static void mce_read_aux(struct mce *m, int i)
+static noinstr void mce_read_aux(struct mce *m, int i)
 {
 	if (m->status & MCI_STATUS_MISCV)
 		m->misc = mce_rdmsrl(msr_ops.misc(i));
-- 
2.34.1

