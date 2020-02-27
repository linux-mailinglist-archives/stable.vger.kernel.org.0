Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8FED17201E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgB0NxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731624AbgB0NxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:53:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3206D20578;
        Thu, 27 Feb 2020 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811582;
        bh=GEmMPpyFw3qXbB0SaqXyk8IradjQvBJNQzdmisvUtZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AR9wE32uE0kHOuTNic2h6vMwkNlcF82GMT2FCwV1c+Jnyt4gW0/eC6C81IkwI4PLe
         MwKXB2zjkCasKcSsI8F6ptQ5XuP3Im2/mQN45gPk5renqi+ms8dqSDy8ZdmnNLdEt+
         XSGKDVfEhR1462vX6W3fbPtziL+4H6F7wtr+YEFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 022/237] arm64: ssbs: Fix context-switch when SSBS is present on all CPUs
Date:   Thu, 27 Feb 2020 14:33:56 +0100
Message-Id: <20200227132257.855894986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit fca3d33d8ad61eb53eca3ee4cac476d1e31b9008 upstream.

When all CPUs in the system implement the SSBS extension, the SSBS field
in PSTATE is the definitive indication of the mitigation state. Further,
when the CPUs implement the SSBS manipulation instructions (advertised
to userspace via an HWCAP), EL0 can toggle the SSBS field directly and
so we cannot rely on any shadow state such as TIF_SSBD at all.

Avoid forcing the SSBS field in context-switch on such a system, and
simply rely on the PSTATE register instead.

Cc: <stable@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Srinivas Ramana <sramana@codeaurora.org>
Fixes: cbdf8a189a66 ("arm64: Force SSBS on context switch")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/process.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -354,6 +354,13 @@ static void ssbs_thread_switch(struct ta
 	if (unlikely(next->flags & PF_KTHREAD))
 		return;
 
+	/*
+	 * If all CPUs implement the SSBS extension, then we just need to
+	 * context-switch the PSTATE field.
+	 */
+	if (cpu_have_feature(cpu_feature(SSBS)))
+		return;
+
 	/* If the mitigation is enabled, then we leave SSBS clear. */
 	if ((arm64_get_ssbd_state() == ARM64_SSBD_FORCE_ENABLE) ||
 	    test_tsk_thread_flag(next, TIF_SSBD))


