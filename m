Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2241CB028
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEHMhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgEHMhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1317D24954;
        Fri,  8 May 2020 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941437;
        bh=K2TFZFRpz3MCU8OdX6oeHUcFcbbl3Srhnap5mdOYprc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHS+2u/bM+dqQpJXql5oHcbBpsa9IbpxNiU9vWPOHBochQKbFSeF2QwVBXhk76289
         jdEa3dIvS/qwXwZpjfnbsvHcQbprcT2bYPSltJPB/oniOYoWnsRxjxaIs/Sjo64+7i
         F7cfj2tCfA1Bem9qRNG6C7HqTnGR+wNLTraVtaYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        linux-mips@linux-mips.org, linux-arch@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 032/312] MIPS: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO
Date:   Fri,  8 May 2020 14:30:23 +0200
Message-Id: <20200508123126.743335733@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

commit 233b2ca181f20674ecad11be90b00814911ce345 upstream.

AT_VECTOR_SIZE_ARCH should be defined with the maximum number of
NEW_AUX_ENT entries that ARCH_DLINFO can contain, but it wasn't defined
for MIPS at all even though ARCH_DLINFO will contain one NEW_AUX_ENT for
the VDSO address.

This shouldn't be a problem as AT_VECTOR_SIZE_BASE includes space for
AT_BASE_PLATFORM which MIPS doesn't use, but lets define it now and add
the comment above ARCH_DLINFO as found in several other architectures to
remind future modifiers of ARCH_DLINFO to keep AT_VECTOR_SIZE_ARCH up to
date.

Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13823/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/elf.h         |    1 +
 arch/mips/include/uapi/asm/auxvec.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -420,6 +420,7 @@ extern const char *__elf_platform;
 #define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
 #endif
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO							\
 do {									\
 	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
--- a/arch/mips/include/uapi/asm/auxvec.h
+++ b/arch/mips/include/uapi/asm/auxvec.h
@@ -14,4 +14,6 @@
 /* Location of VDSO image. */
 #define AT_SYSINFO_EHDR		33
 
+#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
+
 #endif /* __ASM_AUXVEC_H */


