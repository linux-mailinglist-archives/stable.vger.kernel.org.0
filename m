Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C774419CB6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbhI0RbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235746AbhI0R3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D1061205;
        Mon, 27 Sep 2021 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763071;
        bh=tdN4BjEqwC41rKsMl6MwbASAUgaulohMUSFjj23maag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWKz9pLCh02Z/Syqauz/W6myuS1klR0q9Oedc0/8o7HlWTsuPAc+meXZui/Ur5aru
         iuDf4q59Vfr+FnF4vIIX7JURtJ41McUJXaRUv6ZzEnNQGhPdmNx3Hwu7QA41f3ffOV
         jAXae3NRSAgqr2tcVNxhwkx4OR3QA441JhDrlAyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.14 155/162] arm64: add MTE supported check to thread switching and syscall entry/exit
Date:   Mon, 27 Sep 2021 19:03:21 +0200
Message-Id: <20210927170238.792817997@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit 8c8a3b5bd960cd88f7655b5251dc28741e11f139 upstream.

This lets us avoid doing unnecessary work on hardware that does not
support MTE, and will allow us to freely use MTE instructions in the
code called by mte_thread_switch().

Since this would mean that we do a redundant check in
mte_check_tfsr_el1(), remove it and add two checks now required in its
callers. This also avoids an unnecessary DSB+ISB sequence on the syscall
exit path for hardware not supporting MTE.

Fixes: 65812c6921cc ("arm64: mte: Enable async tag check fault")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I02fd000d1ef2c86c7d2952a7f099b254ec227a5d
Link: https://lore.kernel.org/r/20210915190336.398390-1-pcc@google.com
[catalin.marinas@arm.com: adjust the commit log slightly]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mte.h |    6 ++++++
 arch/arm64/kernel/mte.c      |   10 ++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -105,11 +105,17 @@ void mte_check_tfsr_el1(void);
 
 static inline void mte_check_tfsr_entry(void)
 {
+	if (!system_supports_mte())
+		return;
+
 	mte_check_tfsr_el1();
 }
 
 static inline void mte_check_tfsr_exit(void)
 {
+	if (!system_supports_mte())
+		return;
+
 	/*
 	 * The asynchronous faults are sync'ed automatically with
 	 * TFSR_EL1 on kernel entry but for exit an explicit dsb()
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -173,12 +173,7 @@ bool mte_report_once(void)
 #ifdef CONFIG_KASAN_HW_TAGS
 void mte_check_tfsr_el1(void)
 {
-	u64 tfsr_el1;
-
-	if (!system_supports_mte())
-		return;
-
-	tfsr_el1 = read_sysreg_s(SYS_TFSR_EL1);
+	u64 tfsr_el1 = read_sysreg_s(SYS_TFSR_EL1);
 
 	if (unlikely(tfsr_el1 & SYS_TFSR_EL1_TF1)) {
 		/*
@@ -221,6 +216,9 @@ void mte_thread_init_user(void)
 
 void mte_thread_switch(struct task_struct *next)
 {
+	if (!system_supports_mte())
+		return;
+
 	/*
 	 * Check if an async tag exception occurred at EL1.
 	 *


