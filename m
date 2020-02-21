Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02BE1676DF
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgBUH7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730846AbgBUH67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D6120801;
        Fri, 21 Feb 2020 07:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271938;
        bh=qbbsCdrsrCkGn7EAbzaWAaGMdfYyj4oFCK63U/FyJN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ja4hluJ1yMKpLy54WFMb1m0SOhAJ0S3XMnIRBX/HjGqkWDrZBaIAE+kdNiqj/Cq9
         +jlPGHVHh2+QYbjhqUbna2Z2zr9G6s5pAzyeYAIBEWXEngyQu8jW4bvHz7/wml6rfA
         Bx9yr6r0rLNpvYuI2xC9Q5hSzMPlVNeaI0mbcHFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 318/399] x86/decoder: Add TEST opcode to Group3-2
Date:   Fri, 21 Feb 2020 08:40:43 +0100
Message-Id: <20200221072432.307935759@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 8b7e20a7ba54836076ff35a28349dabea4cec48f ]

Add TEST opcode to Group3-2 reg=001b as same as Group3-1 does.

Commit

  12a78d43de76 ("x86/decoder: Add new TEST instruction pattern")

added a TEST opcode assignment to f6 XX/001/XXX (Group 3-1), but did
not add f7 XX/001/XXX (Group 3-2).

Actually, this TEST opcode variant (ModRM.reg /1) is not described in
the Intel SDM Vol2 but in AMD64 Architecture Programmer's Manual Vol.3,
Appendix A.2 Table A-6. ModRM.reg Extensions for the Primary Opcode Map.

Without this fix, Randy found a warning by insn_decoder_test related
to this issue as below.

    HOSTCC  arch/x86/tools/insn_decoder_test
    HOSTCC  arch/x86/tools/insn_sanity
    TEST    posttest
  arch/x86/tools/insn_decoder_test: warning: Found an x86 instruction decoder bug, please report this.
  arch/x86/tools/insn_decoder_test: warning: ffffffff81000bf1:	f7 0b 00 01 08 00    	testl  $0x80100,(%rbx)
  arch/x86/tools/insn_decoder_test: warning: objdump says 6 bytes, but insn_get_length() says 2
  arch/x86/tools/insn_decoder_test: warning: Decoded and checked 11913894 instructions with 1 failures
    TEST    posttest
  arch/x86/tools/insn_sanity: Success: decoded and checked 1000000 random instructions with 0 errors (seed:0x871ce29c)

To fix this error, add the TEST opcode according to AMD64 APM Vol.3.

 [ bp: Massage commit message. ]

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lkml.kernel.org/r/157966631413.9580.10311036595431878351.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/x86-opcode-map.txt       | 2 +-
 tools/arch/x86/lib/x86-opcode-map.txt | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 8908c58bd6cd2..53adc1762ec08 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -929,7 +929,7 @@ EndTable
 
 GrpTable: Grp3_2
 0: TEST Ev,Iz
-1:
+1: TEST Ev,Iz
 2: NOT Ev
 3: NEG Ev
 4: MUL rAX,Ev
diff --git a/tools/arch/x86/lib/x86-opcode-map.txt b/tools/arch/x86/lib/x86-opcode-map.txt
index 8908c58bd6cd2..53adc1762ec08 100644
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -929,7 +929,7 @@ EndTable
 
 GrpTable: Grp3_2
 0: TEST Ev,Iz
-1:
+1: TEST Ev,Iz
 2: NOT Ev
 3: NEG Ev
 4: MUL rAX,Ev
-- 
2.20.1



