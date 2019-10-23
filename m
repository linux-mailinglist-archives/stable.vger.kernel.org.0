Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF0E199C
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391179AbfJWMIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 08:08:05 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:56852 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388063AbfJWMIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 08:08:04 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 4D66D2E14CB;
        Wed, 23 Oct 2019 15:08:01 +0300 (MSK)
Received: from myt4-4db2488e778a.qloud-c.yandex.net (myt4-4db2488e778a.qloud-c.yandex.net [2a02:6b8:c00:884:0:640:4db2:488e])
        by mxbackcorp2j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 23hWWxoMel-7xeeCThm;
        Wed, 23 Oct 2019 15:08:01 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1571832481; bh=+B+SvaOCbgDDknC/2/JkY6GiT3BAkTSKqe+q0hZmdlw=;
        h=In-Reply-To:Message-ID:References:Date:To:From:Subject:Cc;
        b=tzSWkQhA4CPHGRIdvmwXGPPyvByP7Wq4cfsdBGS4wvh9k51+5d0ckRWpwur27Eo7w
         qOw0Ptu+5Uc3rY+hRDT5jeW2E/ERffU4VzoR4PclK96pTOpm17UlVL7lF/7eqiW1nI
         /yLyPpwcNoBsly4QnDJQ8P5Wljg7RAPAtlTUDAn0=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:3d43:d63f:7907:141a])
        by myt4-4db2488e778a.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id lZqZQXZMm5-7xVWhAw5;
        Wed, 23 Oct 2019 15:07:59 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH 4.4 2/2] x86/vdso: Remove hpet_page from vDSO
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>
Date:   Wed, 23 Oct 2019 15:07:59 +0300
Message-ID: <157183247929.2324.17980647890399201165.stgit@buzz>
In-Reply-To: <157183247628.2324.16440279839073827980.stgit@buzz>
References: <157183247628.2324.16440279839073827980.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia Zhang <zhang.jia@linux.alibaba.com>

Commit 81d30225bc0c246b53270eb90b23cfbb941a186d upstream.

This trivial cleanup finalizes the removal of vDSO HPET support.

Fixes: 1ed95e52d902 ("x86/vdso: Remove direct HPET access through the vDSO")
Signed-off-by: Jia Zhang <zhang.jia@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: luto@kernel.org
Cc: bp@alien8.de
Link: https://lkml.kernel.org/r/20190401114045.7280-1-zhang.jia@linux.alibaba.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 arch/x86/entry/vdso/vdso2c.c |    3 ---
 arch/x86/include/asm/vdso.h  |    1 -
 2 files changed, 4 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso2c.c b/arch/x86/entry/vdso/vdso2c.c
index 491020b2826d..6446ba489eb2 100644
--- a/arch/x86/entry/vdso/vdso2c.c
+++ b/arch/x86/entry/vdso/vdso2c.c
@@ -72,7 +72,6 @@ const char *outfilename;
 enum {
 	sym_vvar_start,
 	sym_vvar_page,
-	sym_hpet_page,
 	sym_pvclock_page,
 	sym_VDSO_FAKE_SECTION_TABLE_START,
 	sym_VDSO_FAKE_SECTION_TABLE_END,
@@ -80,7 +79,6 @@ enum {
 
 const int special_pages[] = {
 	sym_vvar_page,
-	sym_hpet_page,
 	sym_pvclock_page,
 };
 
@@ -92,7 +90,6 @@ struct vdso_sym {
 struct vdso_sym required_syms[] = {
 	[sym_vvar_start] = {"vvar_start", true},
 	[sym_vvar_page] = {"vvar_page", true},
-	[sym_hpet_page] = {"hpet_page", true},
 	[sym_pvclock_page] = {"pvclock_page", true},
 	[sym_VDSO_FAKE_SECTION_TABLE_START] = {
 		"VDSO_FAKE_SECTION_TABLE_START", false
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index deabaf9759b6..c2a1188cd0bf 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -21,7 +21,6 @@ struct vdso_image {
 	long sym_vvar_start;  /* Negative offset to the vvar area */
 
 	long sym_vvar_page;
-	long sym_hpet_page;
 	long sym_pvclock_page;
 	long sym_VDSO32_NOTE_MASK;
 	long sym___kernel_sigreturn;

