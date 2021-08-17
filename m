Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D65E3EECE1
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 14:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhHQM4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 08:56:09 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:35879 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhHQM4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 08:56:09 -0400
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id B7F93C06CE;
        Tue, 17 Aug 2021 12:55:34 +0000 (UTC)
Received: (Authenticated sender: ralf@linux-mips.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id EA472C0002;
        Tue, 17 Aug 2021 12:55:11 +0000 (UTC)
Date:   Tue, 17 Aug 2021 14:55:09 +0200
From:   Ralf Baechle <ralf@linux-mips.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     "Maciej W. Rozycki" <macro@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: build failure of mips decstation_r4k_defconfig with binutils-2_37
Message-ID: <YRuxrfYxahPbHmXl@linux-mips.org>
References: <YRujeISiIjKF5eAi@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRujeISiIjKF5eAi@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 12:54:32PM +0100, Sudip Mukherjee wrote:

> While I was testing v5.4.142-rc2 I noticed mips build of
> decstation_r4k_defconfig fails with binutils-2_37. The error is:
> 
> arch/mips/dec/prom/locore.S: Assembler messages:
> arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this
> processor: r4600 (mips3) `rfe'
> 
> I have also reported this at https://sourceware.org/bugzilla/show_bug.cgi?id=28241

It would appear gas got more anal about ISA checking for the RFE instructions
which did only exist in MIPS I and II; MIPS III and later use ERET for
returning from an exception.

The older gas I've got installed here happily accepts RFE in MIPS III/R4000
mode:

$ cat s.s
	rfe
	eret
$ mips-linux-as -o s.o s.s
s.s: Assembler messages:
s.s:2: Error: opcode not supported on this processor: mips1 (mips1) `eret'
$ mips-linux-as -march=r4000 -o s.o s.s
$ mips-linux-objdump -d s.o 

s.o:     file format elf32-tradbigmips


Disassembly of section .text:

00000000 <.text>:
   0:	42000010 	c0	0x10		# <- RFE
   4:	42000018 	eret
	...
$

It's easy to find arguments for why this gas change is the right thing to
do - and not the right thing to do.

It should be fixable by simply putting gas into mips1 mode.  Can you test
below patch?

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/arch/mips/dec/prom/locore.S b/arch/mips/dec/prom/locore.S
index 0eb8fab62ab0..8d00ca8872f9 100644
--- a/arch/mips/dec/prom/locore.S
+++ b/arch/mips/dec/prom/locore.S
@@ -16,6 +16,7 @@
 NESTED(genexcept_early, 0, sp)
 	.set	noat
 	.set	noreorder
+	.set	mips1
 
 	mfc0	k0, CP0_STATUS
 	la	k1, mem_err
