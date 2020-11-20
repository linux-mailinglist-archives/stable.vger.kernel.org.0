Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675FF2BA825
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgKTLEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgKTLEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D0B22264;
        Fri, 20 Nov 2020 11:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870292;
        bh=CUkn8QwlAA/QkP53/gHRq1tV0QPl3sw83I3OFMOUKr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXOe+mtCh7Itbp7+jAhGgfU4U509IxvUH54XSvjkpnJDqcLmuqNiB50Gnp0Shl/T6
         ehZf/RXRMw7MyT+n125YrKpGHm3yUIXEkH8HCO3e74ff357YW6rHHi6x12zcwcNfk6
         pVXROpI7mRajYCF0+Hv6xGItb3gvopxt3Wsv5yRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 4.14 01/17] powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
Date:   Fri, 20 Nov 2020 12:03:12 +0100
Message-Id: <20201120104540.485460161@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
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
@@ -645,6 +645,10 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_TEST_HV, vec);		\
 	EXCEPTION_RELON_PROLOG_PSERIES_1(label, EXC_HV)
 
+#define MASKABLE_RELON_EXCEPTION_PSERIES_OOL(vec, label)               \
+       EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_PR, vec);          \
+       EXCEPTION_PROLOG_PSERIES_1(label, EXC_STD)
+
 /*
  * Our exception common code can be passed various "additions"
  * to specify the behaviour of interrupts, whether to kick the


