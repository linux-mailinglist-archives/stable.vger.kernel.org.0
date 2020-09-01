Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F0D25943F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgIAPhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgIAPhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:37:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BEA20E65;
        Tue,  1 Sep 2020 15:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974639;
        bh=yXRgW0aOwALn1rcUi2JmE2/N6ulJoEuKCS41lc6gquQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYDGQuniJ7j6bUiJPyTAug16/vZK51u9tvgUAbVFNRMSxqkI4HwQyFaHdU2rB1/ih
         CwBv9GLwEtwlOIi9YEAwKTh34diieBNdpgM5w7UCF+BKGFzGsYgUjJMksl4BUqHixK
         Dyr9lfu+p/3TPuF0TipIBuI/qIh7dba9Yz8qWBnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 038/255] MIPS: KVM: Limit Trap-and-Emulate to MIPS32R2 only
Date:   Tue,  1 Sep 2020 17:08:14 +0200
Message-Id: <20200901151002.585715997@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a7e40bb1e5bc6..c43ad3b3cea4b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2203,6 +2203,7 @@ endchoice
 
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



