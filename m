Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D76177F6D
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbgCCRun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:50:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731454AbgCCRum (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABF920CC7;
        Tue,  3 Mar 2020 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257841;
        bh=/0SyJCbMMFWkCsdXw7wEBRFkg92lu0ILXXsUtOZRvWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcEYinLeD1UukmlXiuW+IXaQDVxKQcXgv6lrx9M3ujpu8Leu5qrng0FWF2kkImRPk
         mXfk3DLd0vTSyHsyzAXe+2QO4jcIcckauavrurNagrRvLipRuHaphRKE2MY/Qd3BiD
         3Vj6VfipWlY38Oucr1g3KW8JfnvOkmXaVUcU39kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.5 150/176] lib/vdso: Make __arch_update_vdso_data() logic understandable
Date:   Tue,  3 Mar 2020 18:43:34 +0100
Message-Id: <20200303174322.011346970@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 9a6b55ac4a44060bcb782baf002859b2a2c63267 upstream.

The function name suggests that this is a boolean checking whether the
architecture asks for an update of the VDSO data, but it works the other
way round. To spare further confusion invert the logic.

Fixes: 44f57d788e7d ("timekeeping: Provide a generic update_vsyscall() implementation")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200114185946.656652824@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/vdso/vsyscall.h |    4 ++--
 include/asm-generic/vdso/vsyscall.h  |    4 ++--
 kernel/time/vsyscall.c               |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/include/asm/vdso/vsyscall.h
+++ b/arch/arm/include/asm/vdso/vsyscall.h
@@ -34,9 +34,9 @@ struct vdso_data *__arm_get_k_vdso_data(
 #define __arch_get_k_vdso_data __arm_get_k_vdso_data
 
 static __always_inline
-int __arm_update_vdso_data(void)
+bool __arm_update_vdso_data(void)
 {
-	return !cntvct_ok;
+	return cntvct_ok;
 }
 #define __arch_update_vdso_data __arm_update_vdso_data
 
--- a/include/asm-generic/vdso/vsyscall.h
+++ b/include/asm-generic/vdso/vsyscall.h
@@ -12,9 +12,9 @@ static __always_inline struct vdso_data
 #endif /* __arch_get_k_vdso_data */
 
 #ifndef __arch_update_vdso_data
-static __always_inline int __arch_update_vdso_data(void)
+static __always_inline bool __arch_update_vdso_data(void)
 {
-	return 0;
+	return true;
 }
 #endif /* __arch_update_vdso_data */
 
--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -84,7 +84,7 @@ void update_vsyscall(struct timekeeper *
 	struct vdso_timestamp *vdso_ts;
 	u64 nsec;
 
-	if (__arch_update_vdso_data()) {
+	if (!__arch_update_vdso_data()) {
 		/*
 		 * Some architectures might want to skip the update of the
 		 * data page.


