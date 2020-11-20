Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA02BA803
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgKTLED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgKTLEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D3522264;
        Fri, 20 Nov 2020 11:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870242;
        bh=uYOTG0mv4Raf6spwpp4SpIMpjg4+kJZA3aYN+SlKqSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSe+MSo3e/qXgmnFuyxpeT+zzL+KvaEMM7yfSGycUO0HYfgGtK8qbuDw51FRfgRjp
         rxaQnBpIGUe5leQqe7Ue9J4DHkfpeQfscZjYwfM+R5is4mDlKBpAj0Vx6w0SFsE1tn
         WW/FGS34nGLEkW3bAXWd51SCMbzJjvO3TSdSl+8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 4.9 01/16] powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
Date:   Fri, 20 Nov 2020 12:03:06 +0100
Message-Id: <20201120104539.783072055@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
References: <20201120104539.706905067@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

Commit da2bc4644c75 ("powerpc/64s: Add new exception vector macros")
adds:

+#define __TRAMP_REAL_VIRT_OOL_MASKABLE(name, realvec)          \
+       TRAMP_REAL_BEGIN(tramp_virt_##name);                            \
+       MASKABLE_RELON_EXCEPTION_PSERIES_OOL(realvec, name##_common);   \

However there's no reference there or anywhere else to
MASKABLE_RELON_EXCEPTION_PSERIES_OOL and an attempt to use it
unsurprisingly doesn't work.

Add a definition provided by mpe.

Fixes: da2bc4644c75 ("powerpc/64s: Add new exception vector macros")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/exception-64s.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -563,6 +563,10 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_HV, vec);		\
 	EXCEPTION_PROLOG_PSERIES_1(label, EXC_HV)
 
+#define MASKABLE_RELON_EXCEPTION_PSERIES_OOL(vec, label)               \
+       EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_PR, vec);          \
+       EXCEPTION_PROLOG_PSERIES_1(label, EXC_STD)
+
 /*
  * Our exception common code can be passed various "additions"
  * to specify the behaviour of interrupts, whether to kick the


