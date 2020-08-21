Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96C624DE1A
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgHUR0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgHUQPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB9622B43;
        Fri, 21 Aug 2020 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026509;
        bh=Z5woOFrn9WcoiLa0uM8U8LX6zAA+NteviTzChyljI7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DY9IhwL2JyK5t7WJYWvDGfb1y1WQqQ3PkiLFtp+j7436GEDxbzHxxDz2g/kaNYEwb
         DWi5qofgnt9zMIENyRMFaYLrcbejLNeGydtbCMTDcnbFqPTLLVG5mFuhxBEm0JFAuh
         MvE92CY5H8ocaVI7sEMZjbKln+dkCrROQNnCKSDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 36/62] MIPS: KVM: Limit Trap-and-Emulate to MIPS32R2 only
Date:   Fri, 21 Aug 2020 12:13:57 -0400
Message-Id: <20200821161423.347071-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 01edc5e76ecfecf9a79eec2658f6146ef47bc816 ]

After tons of fixes to get Trap-and-Emulate build on Loongson64,
I've got panic on host machine when trying to run a VM.

I found that it can never work on 64bit systems. Revewing the
code, it looks like R6 can't supportrd by TE as well.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20200710063047.154611-3-jiaxun.yang@flygoat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig     | 1 +
 arch/mips/kvm/Kconfig | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 6fee1a133e9d6..2efc34ed94ebe 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2202,6 +2202,7 @@ endchoice
 
 config KVM_GUEST
 	bool "KVM Guest Kernel"
+	depends on CPU_MIPS32_R2
 	depends on BROKEN_ON_SMP
 	help
 	  Select this option if building a guest kernel for KVM (Trap & Emulate)
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 2bf02d849a3a8..032b3fca6cbba 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -37,10 +37,11 @@ choice
 
 config KVM_MIPS_TE
 	bool "Trap & Emulate"
+	depends on CPU_MIPS32_R2
 	help
 	  Use trap and emulate to virtualize 32-bit guests in user mode. This
 	  does not require any special hardware Virtualization support beyond
-	  standard MIPS32/64 r2 or later, but it does require the guest kernel
+	  standard MIPS32 r2 or later, but it does require the guest kernel
 	  to be configured with CONFIG_KVM_GUEST=y so that it resides in the
 	  user address segment.
 
-- 
2.25.1

