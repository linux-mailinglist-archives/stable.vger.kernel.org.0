Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290E23993DF
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 21:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFBTvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 15:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhFBTvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 15:51:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA7DC061756;
        Wed,  2 Jun 2021 12:49:23 -0700 (PDT)
Date:   Wed, 02 Jun 2021 19:49:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622663361;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=C09bN34SsG6eH0tihYOwKojMT+kiJay7MLv+ig5T4V8=;
        b=yiToU+DgEoG8um8XZXymNvPv/dYo73cgJLJ8rObS+KI77z1YWw5Yx6qn3jJnLF/IEELzRx
        oQgD4RHdZumam/VUUWEGKQN/nViOIKkYZIntsPmNwS5NTix1oTftZZnulhC+RD4pPY6Kz2
        A+6EKDXsa6JENdz0qzShnC+jY1oEL4TpCVlC/yqnftu0hBH9wL/nd1rmPl5/EZVnjXwA9B
        a/3zNQKfJLMJ0fExjRp6ztZbc6vkV2fUBN5ArphK9ttO4HQN5lCM4PVrIwdpFw/rAw85UZ
        PcLoYhnPLLuXce6+2yVuGRc6qKRB5OhEjF87pOxPDY3HlNqjdibdG1PCZYaAkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622663361;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=C09bN34SsG6eH0tihYOwKojMT+kiJay7MLv+ig5T4V8=;
        b=AyBSRAqaAX8fynVNT+92Jg4DjanBs0yRIRnSN8HI+d5FUndbidMRjjrGPX/nIrGI/v9J/q
        oPazmxLMcY8MqsCQ==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] dmaengine: idxd: Use cpu_feature_enabled()
Cc:     Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <162266336134.29796.6074714821595459988.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     db099bafbf5e9c421a3a11cf33965c7b0afb3f89
Gitweb:        https://git.kernel.org/tip/db099bafbf5e9c421a3a11cf33965c7b0afb3f89
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Wed, 02 Jun 2021 12:07:52 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 02 Jun 2021 12:29:00 +02:00

dmaengine: idxd: Use cpu_feature_enabled()

When testing x86 feature bits, use cpu_feature_enabled() so that
build-disabled features can remain off, regardless of what CPUID says.

Fixes: 8e50d392652f ("dmaengine: idxd: Add shared workqueue support")
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
---
 drivers/dma/idxd/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 2a926be..776fd44 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -745,12 +745,12 @@ static int __init idxd_init_module(void)
 	 * If the CPU does not support MOVDIR64B or ENQCMDS, there's no point in
 	 * enumerating the device. We can not utilize it.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_MOVDIR64B)) {
+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 		pr_warn("idxd driver failed to load without MOVDIR64B.\n");
 		return -ENODEV;
 	}
 
-	if (!boot_cpu_has(X86_FEATURE_ENQCMD))
+	if (!cpu_feature_enabled(X86_FEATURE_ENQCMD))
 		pr_warn("Platform does not have ENQCMD(S) support.\n");
 	else
 		support_enqcmd = true;
