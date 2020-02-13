Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF12C15C2FC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgBMPjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbgBMP3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:08 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEAD2206DB;
        Thu, 13 Feb 2020 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607748;
        bh=2hDNtUMZ3bVVDkYuSsiXRwcAD0Gcxj1di8cHa1rNswk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmLbIqqF9NcrHBXAYN//ORoFdxR+yYxbn9ZmfZMREtzq8LkWHhsSDq1AwkNYCjN7g
         hV3lxLDsYZ5eUYEfRHE3jfE7T9l3p4mu5Be66eATpCnY71PJJacfcNBpp7zrJ4Jh8e
         XpYqS6dP9E7R788cnm19ARNrbCajwnGrIpzg0kVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.5 106/120] x86/alternatives: add missing insn.h include
Date:   Thu, 13 Feb 2020 07:21:42 -0800
Message-Id: <20200213151936.373535433@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 3a1255396b5aba40299d5dd5bde67b160a44117f upstream.

From: Dave Hansen <dave.hansen@linux.intel.com>

While testing my MPX removal series, Borislav noted compilation
failure with an allnoconfig build.

Turned out to be a missing include of insn.h in alternative.c.
With MPX, it got it implicitly from:

	asm/mmu_context.h -> asm/mpx.h -> asm/insn.h

Fixes: c3d6324f841b ("x86/alternatives: Teach text_poke_bp() to emulate instructions")
Reported-by: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/alternative.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -23,6 +23,7 @@
 #include <asm/nmi.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/insn.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>
 


