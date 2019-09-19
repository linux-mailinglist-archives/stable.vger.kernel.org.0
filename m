Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2336EB8673
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406484AbfISWRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406465AbfISWRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 298B621920;
        Thu, 19 Sep 2019 22:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931452;
        bh=74nf5UnRKvBiWWXFw3xnxICQuYxH0BWLfryXXrsDYPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIWaTN6WubEgiSqpZCT2ADr2mk78+YpLI3hFTx0ZmcWCbN0SoGRnCZJsD86hQe2rf
         HwYnfSaAQr7M6UlJoHfTMpeSSl/G2yCKd3yFXzSkuagbkdjSf7NfZQKaoAYf6L5is5
         i2yBJnk+GKz/Jh48CVut/kwp5T3MjZhp3vp2JQE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/59] kallsyms: Dont let kallsyms_lookup_size_offset() fail on retrieving the first symbol
Date:   Fri, 20 Sep 2019 00:03:49 +0200
Message-Id: <20190919214806.003059718@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 2a1a3fa0f29270583f0e6e3100d609e09697add1 ]

An arm64 kernel configured with

  CONFIG_KPROBES=y
  CONFIG_KALLSYMS=y
  # CONFIG_KALLSYMS_ALL is not set
  CONFIG_KALLSYMS_BASE_RELATIVE=y

reports the following kprobe failure:

  [    0.032677] kprobes: failed to populate blacklist: -22
  [    0.033376] Please take care of using kprobes.

It appears that kprobe fails to retrieve the symbol at address
0xffff000010081000, despite this symbol being in System.map:

  ffff000010081000 T __exception_text_start

This symbol is part of the first group of aliases in the
kallsyms_offsets array (symbol names generated using ugly hacks in
scripts/kallsyms.c):

  kallsyms_offsets:
          .long   0x1000 // do_undefinstr
          .long   0x1000 // efi_header_end
          .long   0x1000 // _stext
          .long   0x1000 // __exception_text_start
          .long   0x12b0 // do_cp15instr

Looking at the implementation of get_symbol_pos(), it returns the
lowest index for aliasing symbols. In this case, it return 0.

But kallsyms_lookup_size_offset() considers 0 as a failure, which
is obviously wrong (there is definitely a valid symbol living there).
In turn, the kprobe blacklisting stops abruptly, hence the original
error.

A CONFIG_KALLSYMS_ALL kernel wouldn't fail as there is always
some random symbols at the beginning of this array, which are never
looked up via kallsyms_lookup_size_offset.

Fix it by considering that get_symbol_pos() is always successful
(which is consistent with the other uses of this function).

Fixes: ffc5089196446 ("[PATCH] Create kallsyms_lookup_size_offset()")
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kallsyms.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 127e7cfafa552..3e1b66366ac23 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -296,8 +296,10 @@ int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 {
 	char namebuf[KSYM_NAME_LEN];
 
-	if (is_ksym_addr(addr))
-		return !!get_symbol_pos(addr, symbolsize, offset);
+	if (is_ksym_addr(addr)) {
+		get_symbol_pos(addr, symbolsize, offset);
+		return 1;
+	}
 	return !!module_address_lookup(addr, symbolsize, offset, NULL, namebuf) ||
 	       !!__bpf_address_lookup(addr, symbolsize, offset, namebuf);
 }
-- 
2.20.1



