Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A5B1F3F2
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfEOLCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfEOLCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 530E12173C;
        Wed, 15 May 2019 11:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918131;
        bh=ocPwKRRlCaCn1rkgAxJ4KHdN7y14OCX2WTt3yG8gpSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf0ugpg0dfdccdG/FJcO6S9rJgRG6tQovPfLPXLhrKbaHJjGa4YuwRBjcpSXbGhq8
         dSbIISHBFNbPgZdMbfEa7i938NO90BU5aetj/nfcej/WZrbj3laG9Nq+XHSMgdu0ah
         NyjXdXvXizW/b2amVDs7YGzp5gyVS5ecU7YeBm4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 4.4 018/266] powerpc/rfi-flush: Make it possible to call setup_rfi_flush() again
Date:   Wed, 15 May 2019 12:52:05 +0200
Message-Id: <20190515090723.227681699@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit abf110f3e1cea40f5ea15e85f5d67c39c14568a7 upstream.

For PowerVM migration we want to be able to call setup_rfi_flush()
again after we've migrated the partition.

To support that we need to check that we're not trying to allocate the
fallback flush area after memblock has gone away (i.e., boot-time only).

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/setup.h |    2 +-
 arch/powerpc/kernel/setup_64.c   |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -36,7 +36,7 @@ enum l1d_flush_type {
 	L1D_FLUSH_MTTRIG	= 0x8,
 };
 
-void __init setup_rfi_flush(enum l1d_flush_type, bool enable);
+void setup_rfi_flush(enum l1d_flush_type, bool enable);
 void do_rfi_flush_fixups(enum l1d_flush_type types);
 
 #endif /* !__ASSEMBLY__ */
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -887,6 +887,10 @@ static void init_fallback_flush(void)
 	u64 l1d_size, limit;
 	int cpu;
 
+	/* Only allocate the fallback flush area once (at boot time). */
+	if (l1d_flush_fallback_area)
+		return;
+
 	l1d_size = ppc64_caches.dsize;
 	limit = min(safe_stack_limit(), ppc64_rma_size);
 
@@ -904,7 +908,7 @@ static void init_fallback_flush(void)
 	}
 }
 
-void __init setup_rfi_flush(enum l1d_flush_type types, bool enable)
+void setup_rfi_flush(enum l1d_flush_type types, bool enable)
 {
 	if (types & L1D_FLUSH_FALLBACK) {
 		pr_info("rfi-flush: Using fallback displacement flush\n");


