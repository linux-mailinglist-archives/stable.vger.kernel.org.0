Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E7049182E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345189AbiARCoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347514AbiARClb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C6DC035451;
        Mon, 17 Jan 2022 18:36:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E1AB81253;
        Tue, 18 Jan 2022 02:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0F5C36AF6;
        Tue, 18 Jan 2022 02:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473406;
        bh=gToy9rgpXmjmXhO5O+rCXe40u5KiGEURIYJCElHCaJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/BnznOgBETLN8lAKzZSsNkL/3iB0u5VcX9PZhJBSKCkj7dHwxGAjeGG5KREQQO0h
         7/WbXCUtUuBksEgOc0OwfE+xesVoQxD0W/sofOhoSAfjq13YIGZOZhSSFy3Ly2+wdX
         xHQmYNwMfgG2d3uFXcEKKt5Mm1OR4JG1J3Xsr9Yfd4bgNLYZP2SRA+wHNlq3eb5/49
         dPRN280o4orXFhFx3azvO4ZA0ldecJiasKuZ3DJh833s9lU4LcdJoz37+a2YzgA3mg
         jiOQihx7QIxtU/Og3xeltpDfPTOcN1vW0I0gOtcJ8OsAJ3JvN9HnEDGQQkRO1YLneN
         SKYyciGs0JSqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 107/188] x86/mce: Mark mce_read_aux() noinstr
Date:   Mon, 17 Jan 2022 21:30:31 -0500
Message-Id: <20220118023152.1948105-107-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
 arch/x86/kernel/cpu/mce/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index c37a0bcf2744b..e23e74e2f928d 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -691,7 +691,7 @@ static struct notifier_block mce_default_nb = {
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

