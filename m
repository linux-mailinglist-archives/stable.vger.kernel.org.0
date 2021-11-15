Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C8E450E41
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbhKOSNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240190AbhKOSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBC946338B;
        Mon, 15 Nov 2021 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998201;
        bh=5PPyZaNIiiS8KTtXuDXd2EDCWqlpuWnA5BLz6Q1OIL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PG8vBS70cMrtDMksZrHJ8Mw1vw/AewL4BVJf9QaomB2SMwYNjBbcBd4qsWqz7bloK
         FY544Nuh3cbYVWje0p7eKLrVeVExlJhYINGXvWBxk5JlBXtC7wtsa6LG6pbvqWD3tm
         w4KPVInI0S0AlajiJuta22eqJvKgHTzaqEpnuA1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/575] powerpc: Fix is_kvm_guest() / kvm_para_available()
Date:   Mon, 15 Nov 2021 18:02:28 +0100
Message-Id: <20211115165358.408380041@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 95839225639ba7c3d8d7231b542728dcf222bf2d ]

Commit a21d1becaa3f ("powerpc: Reintroduce is_kvm_guest() as a fast-path
check") added is_kvm_guest() and changed kvm_para_available() to use it.

is_kvm_guest() checks a static key, kvm_guest, and that static key is
set in check_kvm_guest().

The problem is check_kvm_guest() is only called on pseries, and even
then only in some configurations. That means is_kvm_guest() always
returns false on all non-pseries and some pseries depending on
configuration. That's a bug.

For PR KVM guests this is noticable because they no longer do live
patching of themselves, which can be detected by the omission of a
message in dmesg such as:

  KVM: Live patching for a fast VM worked

To fix it make check_kvm_guest() an initcall, to ensure it's always
called at boot. It needs to be core so that it runs before
kvm_guest_init() which is postcore. To be an initcall it needs to return
int, where 0 means success, so update that.

We still call it manually in pSeries_smp_probe(), because that runs
before init calls are run.

Fixes: a21d1becaa3f ("powerpc: Reintroduce is_kvm_guest() as a fast-path check")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210623130514.2543232-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_guest.h |  4 ++--
 arch/powerpc/kernel/firmware.c       | 10 ++++++----
 arch/powerpc/platforms/pseries/smp.c |  4 +++-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_guest.h b/arch/powerpc/include/asm/kvm_guest.h
index 2fca299f7e192..c63105d2c9e7c 100644
--- a/arch/powerpc/include/asm/kvm_guest.h
+++ b/arch/powerpc/include/asm/kvm_guest.h
@@ -16,10 +16,10 @@ static inline bool is_kvm_guest(void)
 	return static_branch_unlikely(&kvm_guest);
 }
 
-bool check_kvm_guest(void);
+int check_kvm_guest(void);
 #else
 static inline bool is_kvm_guest(void) { return false; }
-static inline bool check_kvm_guest(void) { return false; }
+static inline int check_kvm_guest(void) { return 0; }
 #endif
 
 #endif /* _ASM_POWERPC_KVM_GUEST_H_ */
diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
index c9e2819b095ab..c7022c41cc314 100644
--- a/arch/powerpc/kernel/firmware.c
+++ b/arch/powerpc/kernel/firmware.c
@@ -23,18 +23,20 @@ EXPORT_SYMBOL_GPL(powerpc_firmware_features);
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
 DEFINE_STATIC_KEY_FALSE(kvm_guest);
-bool check_kvm_guest(void)
+int __init check_kvm_guest(void)
 {
 	struct device_node *hyper_node;
 
 	hyper_node = of_find_node_by_path("/hypervisor");
 	if (!hyper_node)
-		return false;
+		return 0;
 
 	if (!of_device_is_compatible(hyper_node, "linux,kvm"))
-		return false;
+		return 0;
 
 	static_branch_enable(&kvm_guest);
-	return true;
+
+	return 0;
 }
+core_initcall(check_kvm_guest); // before kvm_guest_init()
 #endif
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 9d596b41ec675..f47429323eee9 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -208,7 +208,9 @@ static __init void pSeries_smp_probe(void)
 	if (!cpu_has_feature(CPU_FTR_SMT))
 		return;
 
-	if (check_kvm_guest()) {
+	check_kvm_guest();
+
+	if (is_kvm_guest()) {
 		/*
 		 * KVM emulates doorbells by disabling FSCR[MSGP] so msgsndp
 		 * faults to the hypervisor which then reads the instruction
-- 
2.33.0



