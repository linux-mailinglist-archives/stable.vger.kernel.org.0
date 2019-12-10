Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72FA119DB9
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbfLJWjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbfLJWcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:32:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E09A022464;
        Tue, 10 Dec 2019 22:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017134;
        bh=AD14HuJwAL53Pza8bkEE/Z/IaFe7SMopissPY8SNSzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBeVNsk9F3SsToMr/vFo/oz2baq8ENZaHx8Y83qgmV5fyby3RANyXGUscEv2gc+zB
         F9PITip5ctcC7AEmo2kc1PUS04tBP0yAZIBV2fjVi0W6TuOdWFWSPKYKhDsEmzbLYl
         xN+8AsQzOeer7RjsLvKjiSW2yKAvQzL9k4SoqOPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 82/91] x86/insn: Add some Intel instructions to the opcode map
Date:   Tue, 10 Dec 2019 17:30:26 -0500
Message-Id: <20191210223035.14270-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b980be189c9badba50634671e2303e92bf28e35a ]

Add to the opcode map the following instructions:
        cldemote
        tpause
        umonitor
        umwait
        movdiri
        movdir64b
        enqcmd
        enqcmds
        encls
        enclu
        enclv
        pconfig
        wbnoinvd

For information about the instructions, refer Intel SDM May 2019
(325462-070US) and Intel Architecture Instruction Set Extensions
May 2019 (319433-037).

The instruction decoding can be tested using the perf tools'
"x86 instruction decoder - new instructions" test as folllows:

  $ perf test -v "new " 2>&1 | grep -i cldemote
  Decoded ok: 0f 1c 00                    cldemote (%eax)
  Decoded ok: 0f 1c 05 78 56 34 12        cldemote 0x12345678
  Decoded ok: 0f 1c 84 c8 78 56 34 12     cldemote 0x12345678(%eax,%ecx,8)
  Decoded ok: 0f 1c 00                    cldemote (%rax)
  Decoded ok: 41 0f 1c 00                 cldemote (%r8)
  Decoded ok: 0f 1c 04 25 78 56 34 12     cldemote 0x12345678
  Decoded ok: 0f 1c 84 c8 78 56 34 12     cldemote 0x12345678(%rax,%rcx,8)
  Decoded ok: 41 0f 1c 84 c8 78 56 34 12  cldemote 0x12345678(%r8,%rcx,8)
  $ perf test -v "new " 2>&1 | grep -i tpause
  Decoded ok: 66 0f ae f3                 tpause %ebx
  Decoded ok: 66 0f ae f3                 tpause %ebx
  Decoded ok: 66 41 0f ae f0              tpause %r8d
  $ perf test -v "new " 2>&1 | grep -i umonitor
  Decoded ok: 67 f3 0f ae f0              umonitor %ax
  Decoded ok: f3 0f ae f0                 umonitor %eax
  Decoded ok: 67 f3 0f ae f0              umonitor %eax
  Decoded ok: f3 0f ae f0                 umonitor %rax
  Decoded ok: 67 f3 41 0f ae f0           umonitor %r8d
  $ perf test -v "new " 2>&1 | grep -i umwait
  Decoded ok: f2 0f ae f0                 umwait %eax
  Decoded ok: f2 0f ae f0                 umwait %eax
  Decoded ok: f2 41 0f ae f0              umwait %r8d
  $ perf test -v "new " 2>&1 | grep -i movdiri
  Decoded ok: 0f 38 f9 03                 movdiri %eax,(%ebx)
  Decoded ok: 0f 38 f9 88 78 56 34 12     movdiri %ecx,0x12345678(%eax)
  Decoded ok: 48 0f 38 f9 03              movdiri %rax,(%rbx)
  Decoded ok: 48 0f 38 f9 88 78 56 34 12  movdiri %rcx,0x12345678(%rax)
  $ perf test -v "new " 2>&1 | grep -i movdir64b
  Decoded ok: 66 0f 38 f8 18              movdir64b (%eax),%ebx
  Decoded ok: 66 0f 38 f8 88 78 56 34 12  movdir64b 0x12345678(%eax),%ecx
  Decoded ok: 67 66 0f 38 f8 1c           movdir64b (%si),%bx
  Decoded ok: 67 66 0f 38 f8 8c 34 12     movdir64b 0x1234(%si),%cx
  Decoded ok: 66 0f 38 f8 18              movdir64b (%rax),%rbx
  Decoded ok: 66 0f 38 f8 88 78 56 34 12  movdir64b 0x12345678(%rax),%rcx
  Decoded ok: 67 66 0f 38 f8 18           movdir64b (%eax),%ebx
  Decoded ok: 67 66 0f 38 f8 88 78 56 34 12       movdir64b 0x12345678(%eax),%ecx
  $ perf test -v "new " 2>&1 | grep -i enqcmd
  Decoded ok: f2 0f 38 f8 18              enqcmd (%eax),%ebx
  Decoded ok: f2 0f 38 f8 88 78 56 34 12  enqcmd 0x12345678(%eax),%ecx
  Decoded ok: 67 f2 0f 38 f8 1c           enqcmd (%si),%bx
  Decoded ok: 67 f2 0f 38 f8 8c 34 12     enqcmd 0x1234(%si),%cx
  Decoded ok: f3 0f 38 f8 18              enqcmds (%eax),%ebx
  Decoded ok: f3 0f 38 f8 88 78 56 34 12  enqcmds 0x12345678(%eax),%ecx
  Decoded ok: 67 f3 0f 38 f8 1c           enqcmds (%si),%bx
  Decoded ok: 67 f3 0f 38 f8 8c 34 12     enqcmds 0x1234(%si),%cx
  Decoded ok: f2 0f 38 f8 18              enqcmd (%rax),%rbx
  Decoded ok: f2 0f 38 f8 88 78 56 34 12  enqcmd 0x12345678(%rax),%rcx
  Decoded ok: 67 f2 0f 38 f8 18           enqcmd (%eax),%ebx
  Decoded ok: 67 f2 0f 38 f8 88 78 56 34 12       enqcmd 0x12345678(%eax),%ecx
  Decoded ok: f3 0f 38 f8 18              enqcmds (%rax),%rbx
  Decoded ok: f3 0f 38 f8 88 78 56 34 12  enqcmds 0x12345678(%rax),%rcx
  Decoded ok: 67 f3 0f 38 f8 18           enqcmds (%eax),%ebx
  Decoded ok: 67 f3 0f 38 f8 88 78 56 34 12       enqcmds 0x12345678(%eax),%ecx
  $ perf test -v "new " 2>&1 | grep -i enqcmds
  Decoded ok: f3 0f 38 f8 18              enqcmds (%eax),%ebx
  Decoded ok: f3 0f 38 f8 88 78 56 34 12  enqcmds 0x12345678(%eax),%ecx
  Decoded ok: 67 f3 0f 38 f8 1c           enqcmds (%si),%bx
  Decoded ok: 67 f3 0f 38 f8 8c 34 12     enqcmds 0x1234(%si),%cx
  Decoded ok: f3 0f 38 f8 18              enqcmds (%rax),%rbx
  Decoded ok: f3 0f 38 f8 88 78 56 34 12  enqcmds 0x12345678(%rax),%rcx
  Decoded ok: 67 f3 0f 38 f8 18           enqcmds (%eax),%ebx
  Decoded ok: 67 f3 0f 38 f8 88 78 56 34 12       enqcmds 0x12345678(%eax),%ecx
  $ perf test -v "new " 2>&1 | grep -i encls
  Decoded ok: 0f 01 cf                    encls
  Decoded ok: 0f 01 cf                    encls
  $ perf test -v "new " 2>&1 | grep -i enclu
  Decoded ok: 0f 01 d7                    enclu
  Decoded ok: 0f 01 d7                    enclu
  $ perf test -v "new " 2>&1 | grep -i enclv
  Decoded ok: 0f 01 c0                    enclv
  Decoded ok: 0f 01 c0                    enclv
  $ perf test -v "new " 2>&1 | grep -i pconfig
  Decoded ok: 0f 01 c5                    pconfig
  Decoded ok: 0f 01 c5                    pconfig
  $ perf test -v "new " 2>&1 | grep -i wbnoinvd
  Decoded ok: f3 0f 09                    wbnoinvd
  Decoded ok: f3 0f 09                    wbnoinvd

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Link: http://lore.kernel.org/lkml/20191115135447.6519-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/x86-opcode-map.txt               | 18 ++++++++++++------
 tools/objtool/arch/x86/lib/x86-opcode-map.txt | 18 ++++++++++++------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 1754e094bc288..0f7eb4f5bdb71 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -333,7 +333,7 @@ AVXcode: 1
 06: CLTS
 07: SYSRET (o64)
 08: INVD
-09: WBINVD
+09: WBINVD | WBNOINVD (F3)
 0a:
 0b: UD2 (1B)
 0c:
@@ -364,7 +364,7 @@ AVXcode: 1
 # a ModR/M byte.
 1a: BNDCL Gv,Ev (F3) | BNDCU Gv,Ev (F2) | BNDMOV Gv,Ev (66) | BNDLDX Gv,Ev
 1b: BNDCN Gv,Ev (F2) | BNDMOV Ev,Gv (66) | BNDMK Gv,Ev (F3) | BNDSTX Ev,Gv
-1c:
+1c: Grp20 (1A),(1C)
 1d:
 1e:
 1f: NOP Ev
@@ -792,6 +792,8 @@ f3: Grp17 (1A)
 f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v)
 f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v)
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
+f8: MOVDIR64B Gv,Mdqq (66) | ENQCMD Gv,Mdqq (F2) | ENQCMDS Gv,Mdqq (F3)
+f9: MOVDIRI My,Gy
 EndTable
 
 Table: 3-byte opcode 2 (0x0f 0x3a)
@@ -943,9 +945,9 @@ GrpTable: Grp6
 EndTable
 
 GrpTable: Grp7
-0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B)
-1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B)
-2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B)
+0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B) | PCONFIG (101),(11B) | ENCLV (000),(11B)
+1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B) | ENCLS (111),(11B)
+2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B) | ENCLU (111),(11B)
 3: LIDT Ms
 4: SMSW Mw/Rv
 5: rdpkru (110),(11B) | wrpkru (111),(11B)
@@ -1011,7 +1013,7 @@ GrpTable: Grp15
 3: vstmxcsr Md (v1) | WRGSBASE Ry (F3),(11B)
 4: XSAVE
 5: XRSTOR | lfence (11B)
-6: XSAVEOPT | clwb (66) | mfence (11B)
+6: XSAVEOPT | clwb (66) | mfence (11B) | TPAUSE Rd (66),(11B) | UMONITOR Rv (F3),(11B) | UMWAIT Rd (F2),(11B)
 7: clflush | clflushopt (66) | sfence (11B)
 EndTable
 
@@ -1042,6 +1044,10 @@ GrpTable: Grp19
 6: vscatterpf1qps/d Wx (66),(ev)
 EndTable
 
+GrpTable: Grp20
+0: cldemote Mb
+EndTable
+
 # AMD's Prefetch Group
 GrpTable: GrpP
 0: PREFETCH
diff --git a/tools/objtool/arch/x86/lib/x86-opcode-map.txt b/tools/objtool/arch/x86/lib/x86-opcode-map.txt
index 1754e094bc288..0f7eb4f5bdb71 100644
--- a/tools/objtool/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/objtool/arch/x86/lib/x86-opcode-map.txt
@@ -333,7 +333,7 @@ AVXcode: 1
 06: CLTS
 07: SYSRET (o64)
 08: INVD
-09: WBINVD
+09: WBINVD | WBNOINVD (F3)
 0a:
 0b: UD2 (1B)
 0c:
@@ -364,7 +364,7 @@ AVXcode: 1
 # a ModR/M byte.
 1a: BNDCL Gv,Ev (F3) | BNDCU Gv,Ev (F2) | BNDMOV Gv,Ev (66) | BNDLDX Gv,Ev
 1b: BNDCN Gv,Ev (F2) | BNDMOV Ev,Gv (66) | BNDMK Gv,Ev (F3) | BNDSTX Ev,Gv
-1c:
+1c: Grp20 (1A),(1C)
 1d:
 1e:
 1f: NOP Ev
@@ -792,6 +792,8 @@ f3: Grp17 (1A)
 f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v)
 f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v)
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
+f8: MOVDIR64B Gv,Mdqq (66) | ENQCMD Gv,Mdqq (F2) | ENQCMDS Gv,Mdqq (F3)
+f9: MOVDIRI My,Gy
 EndTable
 
 Table: 3-byte opcode 2 (0x0f 0x3a)
@@ -943,9 +945,9 @@ GrpTable: Grp6
 EndTable
 
 GrpTable: Grp7
-0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B)
-1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B)
-2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B)
+0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B) | PCONFIG (101),(11B) | ENCLV (000),(11B)
+1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B) | ENCLS (111),(11B)
+2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B) | ENCLU (111),(11B)
 3: LIDT Ms
 4: SMSW Mw/Rv
 5: rdpkru (110),(11B) | wrpkru (111),(11B)
@@ -1011,7 +1013,7 @@ GrpTable: Grp15
 3: vstmxcsr Md (v1) | WRGSBASE Ry (F3),(11B)
 4: XSAVE
 5: XRSTOR | lfence (11B)
-6: XSAVEOPT | clwb (66) | mfence (11B)
+6: XSAVEOPT | clwb (66) | mfence (11B) | TPAUSE Rd (66),(11B) | UMONITOR Rv (F3),(11B) | UMWAIT Rd (F2),(11B)
 7: clflush | clflushopt (66) | sfence (11B)
 EndTable
 
@@ -1042,6 +1044,10 @@ GrpTable: Grp19
 6: vscatterpf1qps/d Wx (66),(ev)
 EndTable
 
+GrpTable: Grp20
+0: cldemote Mb
+EndTable
+
 # AMD's Prefetch Group
 GrpTable: GrpP
 0: PREFETCH
-- 
2.20.1

