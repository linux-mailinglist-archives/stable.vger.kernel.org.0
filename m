Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8633D2E3C69
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436875AbgL1OCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436869AbgL1OCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2A24207AB;
        Mon, 28 Dec 2020 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164110;
        bh=CW7sfNxjmiuSU4N04oyKZ7us6J5vXrFyc5Nu30RjiKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=id62iS/uJD1zoy39O/b7Ap18M4ITG6TwJ14ghRKu0q5LAlHpw48MT+RucQD32+NpY
         vJ16PEYE6EdjMfohPWNJKFp6Bv72utXHTMmcalpAwCiurXW/2rWsQbo17vpKMF+UUm
         cwIlpUjfHf7O4PujMTz27eWD7pRq4qbIyBg8DEvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/717] x86/mce: Correct the detection of invalid notifier priorities
Date:   Mon, 28 Dec 2020 13:41:01 +0100
Message-Id: <20201228125024.015298296@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 15af36596ae305aefc8c502c2d3e8c58221709eb ]

Commit

  c9c6d216ed28 ("x86/mce: Rename "first" function as "early"")

changed the enumeration of MCE notifier priorities. Correct the check
for notifier priorities to cover the new range.

 [ bp: Rewrite commit message, remove superfluous brackets in
   conditional. ]

Fixes: c9c6d216ed28 ("x86/mce: Rename "first" function as "early"")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201106141216.2062-2-thunder.leizhen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/mce.h     | 3 ++-
 arch/x86/kernel/cpu/mce/core.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index a0f147893a041..fc25c88c7ff29 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -177,7 +177,8 @@ enum mce_notifier_prios {
 	MCE_PRIO_EXTLOG,
 	MCE_PRIO_UC,
 	MCE_PRIO_EARLY,
-	MCE_PRIO_CEC
+	MCE_PRIO_CEC,
+	MCE_PRIO_HIGHEST = MCE_PRIO_CEC
 };
 
 struct notifier_block;
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 32b7099e35111..311688202ea51 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -162,7 +162,8 @@ EXPORT_SYMBOL_GPL(mce_log);
 
 void mce_register_decode_chain(struct notifier_block *nb)
 {
-	if (WARN_ON(nb->priority > MCE_PRIO_MCELOG && nb->priority < MCE_PRIO_EDAC))
+	if (WARN_ON(nb->priority < MCE_PRIO_LOWEST ||
+		    nb->priority > MCE_PRIO_HIGHEST))
 		return;
 
 	blocking_notifier_chain_register(&x86_mce_decoder_chain, nb);
-- 
2.27.0



