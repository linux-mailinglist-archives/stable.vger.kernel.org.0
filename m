Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5500A491DF8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346439AbiARDpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350715AbiARCwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:52:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCB3C07E5FD;
        Mon, 17 Jan 2022 18:42:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2A2608C0;
        Tue, 18 Jan 2022 02:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0ABCC36AEB;
        Tue, 18 Jan 2022 02:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473773;
        bh=nnmFS4snQfH4IgxLfKCjV44SRCnnUshUmD3/lNSIPSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imfcGttqxsJ2rkZqtGFIdz/Lq1nzSTAWZ/iryvzPccDx4wCkGmgq2fMFi9kGa8nt9
         GeQjIcClk0HyrbZOCfeFwuaXWl+Y5FCGjbdT3UAHxlgmzapQAtpCYiNFP1rcVnHhk/
         LgzEfzDCtNy3z6yZG8kQFj4976W+1KLU0ixcoE2Pb3UTl/4mUagigw4kV8FQwU35QW
         4NJmyImQqijLB5ujTidCOSn2TadyIxzcX8AKSJEL5vGaZH0EJ4LC/QzNUhRJm+Pdxq
         FHJ+K8ksc/UVr6SehVpNQSwQzke1RSIWZI4hBtXz4w8vS1YEMXgKtiGKPE67EpaJnd
         peZjdYU/dp/eA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 064/116] x86/mce: Mark mce_read_aux() noinstr
Date:   Mon, 17 Jan 2022 21:39:15 -0500
Message-Id: <20220118024007.1950576-64-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 2a608f0819765..5cf1a024408bf 100644
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

