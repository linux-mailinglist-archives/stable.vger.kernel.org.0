Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A8881C08
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbfHENTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729672AbfHENTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF00216F4;
        Mon,  5 Aug 2019 13:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011179;
        bh=eeFIHSL2xp6/VvCSYq3PlJ1aasNV2jep2XmQvnOX6eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wE7/Wte9VDmTxACJ5fmXwcvlrTVwfY3X9jckfN6Wu8qyGVkvgq1qFItK6rp7Lw14v
         FPoEp75YaVgnqCwc1sMBrREOIsrtTbPrWUWVKrLDuAAVWQyb2c4FN6NQonHJgx68Ri
         z55vuJcsoXXkELjSLjWVh5Kk1Ldvxbi/ITXRO8Lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Duncan Roe <duncan_roe@optusnet.com.au>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 73/74] x86/vdso: Prevent segfaults due to hoisted vclock reads
Date:   Mon,  5 Aug 2019 15:03:26 +0200
Message-Id: <20190805124941.688410363@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit ff17bbe0bb405ad8b36e55815d381841f9fdeebc upstream.

GCC 5.5.0 sometimes cleverly hoists reads of the pvclock and/or hvclock
pages before the vclock mode checks.  This creates a path through
vclock_gettime() in which no vclock is enabled at all (due to disabled
TSC on old CPUs, for example) but the pvclock or hvclock page
nevertheless read.  This will segfault on bare metal.

This fixes commit 459e3a21535a ("gcc-9: properly declare the
{pv,hv}clock_page storage") in the sense that, before that commit, GCC
didn't seem to generate the offending code.  There was nothing wrong
with that commit per se, and -stable maintainers should backport this to
all supported kernels regardless of whether the offending commit was
present, since the same crash could just as easily be triggered by the
phase of the moon.

On GCC 9.1.1, this doesn't seem to affect the generated code at all, so
I'm not too concerned about performance regressions from this fix.

Cc: stable@vger.kernel.org
Cc: x86@kernel.org
Cc: Borislav Petkov <bp@alien8.de>
Reported-by: Duncan Roe <duncan_roe@optusnet.com.au>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/vdso/vclock_gettime.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/vdso/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vclock_gettime.c
@@ -191,13 +191,24 @@ notrace static inline u64 vgetsns(int *m
 
 	if (gtod->vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
+
+	/*
+	 * For any memory-mapped vclock type, we need to make sure that gcc
+	 * doesn't cleverly hoist a load before the mode check.  Otherwise we
+	 * might end up touching the memory-mapped page even if the vclock in
+	 * question isn't enabled, which will segfault.  Hence the barriers.
+	 */
 #ifdef CONFIG_PARAVIRT_CLOCK
-	else if (gtod->vclock_mode == VCLOCK_PVCLOCK)
+	else if (gtod->vclock_mode == VCLOCK_PVCLOCK) {
+		barrier();
 		cycles = vread_pvclock(mode);
+	}
 #endif
 #ifdef CONFIG_HYPERV_TSCPAGE
-	else if (gtod->vclock_mode == VCLOCK_HVCLOCK)
+	else if (gtod->vclock_mode == VCLOCK_HVCLOCK) {
+		barrier();
 		cycles = vread_hvclock(mode);
+	}
 #endif
 	else
 		return 0;


