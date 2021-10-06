Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FA9424477
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 19:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhJFRky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 13:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbhJFRky (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 13:40:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4484C061746;
        Wed,  6 Oct 2021 10:39:01 -0700 (PDT)
Date:   Wed, 06 Oct 2021 17:38:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633541940;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzkewje614p/2xlfuJ71zykIP673FLGg4ncaj2qx4ac=;
        b=gEWvvsNhtrdymyI2WIUTf5v1w17D0YgUaJeft85d+L9TXm9ZXmgmGmUGh3srDX9Q/gzBlk
        S+ZdxpvxpjWQQbyYJdgg9ZOs7eazFYPeJtway2l5Vb0O16oiEa6uXfLN2eS/turSCCd/0I
        BNfQ1hP4o3RdOamUSifY8YJHiWqCdJ/OGIk8aqxhSwrOyknnMA5AbCiBis64GYHQjKSBL+
        cR4c5Cj6CCUID8y30MLCO78Sw1P/IszXuaq0PZxHem67+vaRMSG1TqA27kYfwNuxAxl+Go
        scB50fSgbuO9jmEC803eQe1f1dYPcc/2DUKcUjLiTE66OItaVAeGhHy54PB98w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633541940;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzkewje614p/2xlfuJ71zykIP673FLGg4ncaj2qx4ac=;
        b=rG6AXK9v+aKGgsnBn2Ew0pJymhbahIfaWB+hYsojOalQ7mmTbjcnd0r2uxH9+jEyuyCShQ
        ISwe4Ag6iOB6IQCw==
From:   "tip-bot2 for Lukas Bulwahn" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry: Correct reference to intended CONFIG_64_BIT
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210803113531.30720-2-lukas.bulwahn@gmail.com>
References: <20210803113531.30720-2-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Message-ID: <163354193927.25758.17182020598657218922.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     2c861f2b859385e9eaa6e464a8a7435b5a6bf564
Gitweb:        https://git.kernel.org/tip/2c861f2b859385e9eaa6e464a8a7435b5a6bf564
Author:        Lukas Bulwahn <lukas.bulwahn@gmail.com>
AuthorDate:    Tue, 03 Aug 2021 13:35:23 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 06 Oct 2021 18:46:02 +02:00

x86/entry: Correct reference to intended CONFIG_64_BIT

Commit in Fixes adds a condition with IS_ENABLED(CONFIG_64_BIT),
but the intended config item is called CONFIG_64BIT, as defined in
arch/x86/Kconfig.

Fortunately, scripts/checkkconfigsymbols.py warns:

64_BIT
Referencing files: arch/x86/include/asm/entry-common.h

Correct the reference to the intended config symbol.

Fixes: 662a0221893a ("x86/entry: Fix AC assertion")
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210803113531.30720-2-lukas.bulwahn@gmail.com
---
 arch/x86/include/asm/entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index 14ebd21..4318464 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -25,7 +25,7 @@ static __always_inline void arch_check_user_regs(struct pt_regs *regs)
 		 * For !SMAP hardware we patch out CLAC on entry.
 		 */
 		if (boot_cpu_has(X86_FEATURE_SMAP) ||
-		    (IS_ENABLED(CONFIG_64_BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
+		    (IS_ENABLED(CONFIG_64BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
 			mask |= X86_EFLAGS_AC;
 
 		WARN_ON_ONCE(flags & mask);
