Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CCC79633
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390583AbfG2Tto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390582AbfG2Ttn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:49:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A5F2054F;
        Mon, 29 Jul 2019 19:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429782;
        bh=rycWlM73bk/G8i6/qEfXoOpl3dhfEKYLIyS02+s6Yoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLtna8cmfuSc6TKCmINdqx2Lm5SbWcHTjas8gD9F11//DshFcfoH5niNQJZo/TrOk
         YzNMbRV3r+96V9vN2V5mDD9Q46ps6osUpzkdrN5SgzRTaeRhN7xPlnid8+OT3aZvk/
         qhtd14jHsv+IR81MomiYE05ESx5R4oRVjqSXV8JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 094/215] recordmcount: Fix spurious mcount entries on powerpc
Date:   Mon, 29 Jul 2019 21:21:30 +0200
Message-Id: <20190729190755.590558216@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80e5302e4bc85a6b685b7668c36c6487b5f90e9a ]

An impending change to enable HAVE_C_RECORDMCOUNT on powerpc leads to
warnings such as the following:

  # modprobe kprobe_example
  ftrace-powerpc: Not expected bl: opcode is 3c4c0001
  WARNING: CPU: 0 PID: 227 at kernel/trace/ftrace.c:2001 ftrace_bug+0x90/0x318
  Modules linked in:
  CPU: 0 PID: 227 Comm: modprobe Not tainted 5.2.0-rc6-00678-g1c329100b942 #2
  NIP:  c000000000264318 LR: c00000000025d694 CTR: c000000000f5cd30
  REGS: c000000001f2b7b0 TRAP: 0700   Not tainted  (5.2.0-rc6-00678-g1c329100b942)
  MSR:  900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 28228222  XER: 00000000
  CFAR: c0000000002642fc IRQMASK: 0
  <snip>
  NIP [c000000000264318] ftrace_bug+0x90/0x318
  LR [c00000000025d694] ftrace_process_locs+0x4f4/0x5e0
  Call Trace:
  [c000000001f2ba40] [0000000000000004] 0x4 (unreliable)
  [c000000001f2bad0] [c00000000025d694] ftrace_process_locs+0x4f4/0x5e0
  [c000000001f2bb90] [c00000000020ff10] load_module+0x25b0/0x30c0
  [c000000001f2bd00] [c000000000210cb0] sys_finit_module+0xc0/0x130
  [c000000001f2be20] [c00000000000bda4] system_call+0x5c/0x70
  Instruction dump:
  419e0018 2f83ffff 419e00bc 2f83ffea 409e00cc 4800001c 0fe00000 3c62ff96
  39000001 39400000 386386d0 480000c4 <0fe00000> 3ce20003 39000001 3c62ff96
  ---[ end trace 4c438d5cebf78381 ]---
  ftrace failed to modify
  [<c0080000012a0008>] 0xc0080000012a0008
   actual:   01:00:4c:3c
  Initializing ftrace call sites
  ftrace record flags: 2000000
   (0)
   expected tramp: c00000000006af4c

Looking at the relocation records in __mcount_loc shows a few spurious
entries:

  RELOCATION RECORDS FOR [__mcount_loc]:
  OFFSET           TYPE              VALUE
  0000000000000000 R_PPC64_ADDR64    .text.unlikely+0x0000000000000008
  0000000000000008 R_PPC64_ADDR64    .text.unlikely+0x0000000000000014
  0000000000000010 R_PPC64_ADDR64    .text.unlikely+0x0000000000000060
  0000000000000018 R_PPC64_ADDR64    .text.unlikely+0x00000000000000b4
  0000000000000020 R_PPC64_ADDR64    .init.text+0x0000000000000008
  0000000000000028 R_PPC64_ADDR64    .init.text+0x0000000000000014

The first entry in each section is incorrect. Looking at the
relocation records, the spurious entries correspond to the
R_PPC64_ENTRY records:

  RELOCATION RECORDS FOR [.text.unlikely]:
  OFFSET           TYPE              VALUE
  0000000000000000 R_PPC64_REL64     .TOC.-0x0000000000000008
  0000000000000008 R_PPC64_ENTRY     *ABS*
  0000000000000014 R_PPC64_REL24     _mcount
  <snip>

The problem is that we are not validating the return value from
get_mcountsym() in sift_rel_mcount(). With this entry, mcountsym is 0,
but Elf_r_sym(relp) also ends up being 0. Fix this by ensuring
mcountsym is valid before processing the entry.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/recordmcount.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 13c5e6c8829c..47fca2c69a73 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -325,7 +325,8 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 		if (!mcountsym)
 			mcountsym = get_mcountsym(sym0, relp, str0);
 
-		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
+		if (mcountsym && mcountsym == Elf_r_sym(relp) &&
+				!is_fake_mcount(relp)) {
 			uint_t const addend =
 				_w(_w(relp->r_offset) - recval + mcount_adjust);
 			mrelp->r_offset = _w(offbase
-- 
2.20.1



