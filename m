Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7848468D8ED
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjBGNOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjBGNOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:14:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A51C27D6B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A343CE1DB1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A54C433EF;
        Tue,  7 Feb 2023 13:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775596;
        bh=+4MgNm7jobg0Th/28M5WXMhfu5tTKoujsHCRE8soPbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzKgPP3tFAwIqoS4rSv2LJrgETu/dDYA2WiWJZk9V9uIYVETiviTBl/62fNXmxHgi
         lIConoCKT9P+m1pPdlLdroKar5zq2fyRrV+xCOV81TfGMMXTyXYieAmLqDpHiB5Vb2
         jlotG0mmEWKbpWCeSRV4qPtVIWt6efdWqe21n5vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 093/120] x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses
Date:   Tue,  7 Feb 2023 13:57:44 +0100
Message-Id: <20230207125622.729221154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 9d2c7203ffdb846399b82b0660563c89e918c751 upstream.

In kernels compiled with CONFIG_PARAVIRT=n, the compiler re-orders the
DR7 read in exc_nmi() to happen before the call to sev_es_ist_enter().

This is problematic when running as an SEV-ES guest because in this
environment the DR7 read might cause a #VC exception, and taking #VC
exceptions is not safe in exc_nmi() before sev_es_ist_enter() has run.

The result is stack recursion if the NMI was caused on the #VC IST
stack, because a subsequent #VC exception in the NMI handler will
overwrite the stack frame of the interrupted #VC handler.

As there are no compiler barriers affecting the ordering of DR7
reads/writes, make the accesses to this register volatile, forbidding
the compiler to re-order them.

  [ bp: Massage text, make them volatile too, to make sure some
  aggressive compiler optimization pass doesn't discard them. ]

Fixes: 315562c9af3d ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Reported-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230127035616.508966-1-aik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/debugreg.h |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -39,7 +39,20 @@ static __always_inline unsigned long nat
 		asm("mov %%db6, %0" :"=r" (val));
 		break;
 	case 7:
-		asm("mov %%db7, %0" :"=r" (val));
+		/*
+		 * Apply __FORCE_ORDER to DR7 reads to forbid re-ordering them
+		 * with other code.
+		 *
+		 * This is needed because a DR7 access can cause a #VC exception
+		 * when running under SEV-ES. Taking a #VC exception is not a
+		 * safe thing to do just anywhere in the entry code and
+		 * re-ordering might place the access into an unsafe location.
+		 *
+		 * This happened in the NMI handler, where the DR7 read was
+		 * re-ordered to happen before the call to sev_es_ist_enter(),
+		 * causing stack recursion.
+		 */
+		asm volatile("mov %%db7, %0" : "=r" (val) : __FORCE_ORDER);
 		break;
 	default:
 		BUG();
@@ -66,7 +79,16 @@ static __always_inline void native_set_d
 		asm("mov %0, %%db6"	::"r" (value));
 		break;
 	case 7:
-		asm("mov %0, %%db7"	::"r" (value));
+		/*
+		 * Apply __FORCE_ORDER to DR7 writes to forbid re-ordering them
+		 * with other code.
+		 *
+		 * While is didn't happen with a DR7 write (see the DR7 read
+		 * comment above which explains where it happened), add the
+		 * __FORCE_ORDER here too to avoid similar problems in the
+		 * future.
+		 */
+		asm volatile("mov %0, %%db7"	::"r" (value), __FORCE_ORDER);
 		break;
 	default:
 		BUG();


