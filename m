Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A14A8A5B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbfIDP7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731514AbfIDP7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5A4520820;
        Wed,  4 Sep 2019 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612744;
        bh=tIOyhS6VF6IaTHZxXUaqI8fByJAKFcQIdfAgqKw19ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Smn81ya7D1GfbqPi/G4kC7ez/9sjys13gDaWYvtZPfpoMkc6H2tJjEIo1XrGimdlo
         5QUmJDoKQal4Rtj4xeO8t6Y6pMn+V7z44JBYs74O5xmm5jkf3PwKbKZkxpChXpYoow
         y2ZXjo1B4pAo1YM/bwX4WZOC8+cZsF+n987cyi0k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 56/94] kallsyms: Don't let kallsyms_lookup_size_offset() fail on retrieving the first symbol
Date:   Wed,  4 Sep 2019 11:57:01 -0400
Message-Id: <20190904155739.2816-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 95a260f9214b9..136ce049c4ad2 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -263,8 +263,10 @@ int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
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

