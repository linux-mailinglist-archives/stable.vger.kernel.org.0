Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC48E461EDE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhK2SlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:41:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40312 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379038AbhK2SjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:39:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAB55B815A9;
        Mon, 29 Nov 2021 18:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2885C53FAD;
        Mon, 29 Nov 2021 18:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210965;
        bh=wXmKNaD7mOr8fG8sF3G5HyAU++tqRBQv5nhsQOXCoMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e30oPr0cF4ek3CmI7I/kMpI3KxJM5z6jH617tzoktNWFvZ+l+gmRP+ttFL/PdYtv5
         sTJ5HAZhXEP2u4Y2CNUUbIvSMKoAdcuBizuG/sLgKYQlsQToql+r6V4IgxsRRKVz6V
         uDHXZaGRzixqkhSnjOujvyTtRLUbHgu5pFnEP1MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 055/179] powerpc/32: Fix hardlockup on vmap stack overflow
Date:   Mon, 29 Nov 2021 19:17:29 +0100
Message-Id: <20211129181720.780547229@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 5bb60ea611db1e04814426ed4bd1c95d1487678e upstream.

Since the commit c118c7303ad5 ("powerpc/32: Fix vmap stack - Do not
activate MMU before reading task struct") a vmap stack overflow
results in a hard lockup. This is because emergency_ctx is still
addressed with its virtual address allthough data MMU is not active
anymore at that time.

Fix it by using a physical address instead.

Fixes: c118c7303ad5 ("powerpc/32: Fix vmap stack - Do not activate MMU before reading task struct")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/ce30364fb7ccda489272af4a1612b6aa147e1d23.1637227521.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_32.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -202,11 +202,11 @@ vmap_stack_overflow:
 	mfspr	r1, SPRN_SPRG_THREAD
 	lwz	r1, TASK_CPU - THREAD(r1)
 	slwi	r1, r1, 3
-	addis	r1, r1, emergency_ctx@ha
+	addis	r1, r1, emergency_ctx-PAGE_OFFSET@ha
 #else
-	lis	r1, emergency_ctx@ha
+	lis	r1, emergency_ctx-PAGE_OFFSET@ha
 #endif
-	lwz	r1, emergency_ctx@l(r1)
+	lwz	r1, emergency_ctx-PAGE_OFFSET@l(r1)
 	addi	r1, r1, THREAD_SIZE - INT_FRAME_SIZE
 	EXCEPTION_PROLOG_2 0 vmap_stack_overflow
 	prepare_transfer_to_handler


