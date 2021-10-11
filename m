Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DA2428F97
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbhJKN7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238380AbhJKN6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F71A610F8;
        Mon, 11 Oct 2021 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960511;
        bh=sP/k0sPMtXGbC4p13c1Boye9VVTcVoWXLD4I77BSL9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OK5ruXQmFqkIY09k4vDcR3cobqfU4G18v9ngQTDJvD22iioVmnzzaQHsoNdbSSfOk
         tY+bHM1BG3KhdtETOULKfiCbZL86kN5vR+hdsTajtwSQqrUhf3sDcOSfdQGG4tLq0w
         FX9lmzm7Ut5xVbVt8QD5ym/7D1PJ+UOJwCWib9kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 81/83] x86/entry: Clear X86_FEATURE_SMAP when CONFIG_X86_SMAP=n
Date:   Mon, 11 Oct 2021 15:46:41 +0200
Message-Id: <20211011134511.168199120@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 3958b9c34c2729597e182cc606cc43942fd19f7c upstream.

Commit

  3c73b81a9164 ("x86/entry, selftests: Further improve user entry sanity checks")

added a warning if AC is set when in the kernel.

Commit

  662a0221893a3d ("x86/entry: Fix AC assertion")

changed the warning to only fire if the CPU supports SMAP.

However, the warning can still trigger on a machine that supports SMAP
but where it's disabled in the kernel config and when running the
syscall_nt selftest, for example:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 49 at irqentry_enter_from_user_mode
  CPU: 0 PID: 49 Comm: init Tainted: G                T 5.15.0-rc4+ #98 e6202628ee053b4f310759978284bd8bb0ce6905
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
  RIP: 0010:irqentry_enter_from_user_mode
  ...
  Call Trace:
   ? irqentry_enter
   ? exc_general_protection
   ? asm_exc_general_protection
   ? asm_exc_general_protectio

IS_ENABLED(CONFIG_X86_SMAP) could be added to the warning condition, but
even this would not be enough in case SMAP is disabled at boot time with
the "nosmap" parameter.

To be consistent with "nosmap" behaviour, clear X86_FEATURE_SMAP when
!CONFIG_X86_SMAP.

Found using entry-fuzz + satrandconfig.

 [ bp: Massage commit message. ]

Fixes: 3c73b81a9164 ("x86/entry, selftests: Further improve user entry sanity checks")
Fixes: 662a0221893a ("x86/entry: Fix AC assertion")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211003223423.8666-1-vegard.nossum@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -320,6 +320,7 @@ static __always_inline void setup_smap(s
 #ifdef CONFIG_X86_SMAP
 		cr4_set_bits(X86_CR4_SMAP);
 #else
+		clear_cpu_cap(c, X86_FEATURE_SMAP);
 		cr4_clear_bits(X86_CR4_SMAP);
 #endif
 	}


