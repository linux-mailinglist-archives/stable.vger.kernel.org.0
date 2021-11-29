Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D318C462733
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbhK2XBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237014AbhK2XAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E816C127B76;
        Mon, 29 Nov 2021 10:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2591BB815AE;
        Mon, 29 Nov 2021 18:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA41C53FC7;
        Mon, 29 Nov 2021 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210551;
        bh=zN+n3mwPS+RxpkyDqheAQc+UjIIJ+yEeCftKuNC7gOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBpt+oitj9YA042m84hHEjQlwOUZozCoeOWNuJUELRT7GQ9v2f7mzlBUMQUr1OSjX
         gJsGkAww9UJX5E5ydu0PMfCV2S1EYqf18D0t09Wb4HXOpPJpvHjwVkHmPrdlgtMkil
         6zPVtlr2gvH8Zhb7z2q9jdXCEnXtrlfASCE+pwBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 034/121] powerpc/32: Fix hardlockup on vmap stack overflow
Date:   Mon, 29 Nov 2021 19:17:45 +0100
Message-Id: <20211129181712.794330996@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
@@ -333,11 +333,11 @@ label:
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
 	EXCEPTION_PROLOG_2
 	SAVE_NVGPRS(r11)


