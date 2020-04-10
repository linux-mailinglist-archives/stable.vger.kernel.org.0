Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7CB1A410E
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgDJDrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbgDJDrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:47:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48DEC20CC7;
        Fri, 10 Apr 2020 03:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490452;
        bh=kkvZbA2vkPiq5mVjy9hdXDb2Jqew+F4v57ty+HGHEU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/c6OG+6b3/oMHFuMrQQzIWi60l7XmEh4b7Iv+0ITEVmOTIWB39bzsIWMnT6fNreN
         9rD/fj+fZsTzlwCZX410zSKdke3pyCgxycAPGC4+J0loA7+GatKpyLkcRCTTTSgAxN
         JlVwxOCqXyHeAEnPDJLylAvpq4Bzlxmrv0985650=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 48/68] x86/boot: Use unsigned comparison for addresses
Date:   Thu,  9 Apr 2020 23:46:13 -0400
Message-Id: <20200410034634.7731-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 81a34892c2c7c809f9c4e22c5ac936ae673fb9a2 ]

The load address is compared with LOAD_PHYSICAL_ADDR using a signed
comparison currently (using jge instruction).

When loading a 64-bit kernel using the new efi32_pe_entry() point added by:

  97aa276579b2 ("efi/x86: Add true mixed mode entry point into .compat section")

using Qemu with -m 3072, the firmware actually loads us above 2Gb,
resulting in a very early crash.

Use the JAE instruction to perform a unsigned comparison instead, as physical
addresses should be considered unsigned.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200301230436.2246909-6-nivedita@alum.mit.edu
Link: https://lore.kernel.org/r/20200308080859.21568-14-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/head_32.S | 2 +-
 arch/x86/boot/compressed/head_64.S | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 73f17d0544dd5..7f7e8b8518fec 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -106,7 +106,7 @@ SYM_FUNC_START(startup_32)
 	notl	%eax
 	andl    %eax, %ebx
 	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
-	jge	1f
+	jae	1f
 #endif
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 1:
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 1f1f6c8139b38..afde2aa8382e9 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -106,7 +106,7 @@ SYM_FUNC_START(startup_32)
 	notl	%eax
 	andl	%eax, %ebx
 	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
-	jge	1f
+	jae	1f
 #endif
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 1:
@@ -296,7 +296,7 @@ SYM_CODE_START(startup_64)
 	notq	%rax
 	andq	%rax, %rbp
 	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
-	jge	1f
+	jae	1f
 #endif
 	movq	$LOAD_PHYSICAL_ADDR, %rbp
 1:
-- 
2.20.1

