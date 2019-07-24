Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9FC7399B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390264AbfGXTlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390226AbfGXTlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D3B322ADC;
        Wed, 24 Jul 2019 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997310;
        bh=qNSDS/2ZUqdhaF11qha9ikyFePudgmOBzxEyE29dK0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpcuYYl9fzn5uqPy4HR39XHQF6WZbS3Dqm8E0Grpfsz+9aDJiiLiaAjdAtPnq/UGO
         iRyEXwS4QEaMDqlQM6a8FHV+nVbPF+ELDokyIGuNRajpudO0iIt1eUw/RBJUaGUl/M
         Tb2W1b0JGYuI+xzr1LUjK1wBylJd/4UZOKe65yFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.2 385/413] parisc: Avoid kernel panic triggered by invalid kprobe
Date:   Wed, 24 Jul 2019 21:21:16 +0200
Message-Id: <20190724191802.546609801@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 59a783dbc0d5fd6792aabff933055373b6dcbf2a upstream.

When running gdb I was able to trigger this kernel panic:

 Kernel Fault: Code=26 (Data memory access rights trap) at addr 0000000000000060
 CPU: 0 PID: 1401 Comm: gdb-crash Not tainted 5.2.0-rc7-64bit+ #1053

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
 PSW: 00001000000001000000000000001111 Not tainted
 r00-03  000000000804000f 0000000040dee1a0 0000000040c78cf0 00000000b8d50160
 r04-07  0000000040d2b1a0 000000004360a098 00000000bbbe87b8 0000000000000003
 r08-11  00000000fac20a70 00000000fac24160 00000000fac1bbe0 0000000000000000
 r12-15  00000000fabfb79a 00000000fac244a4 0000000000010000 0000000000000001
 r16-19  00000000bbbe87b8 00000000f8f02910 0000000000010034 0000000000000000
 r20-23  00000000fac24630 00000000fac24630 000000006474e552 00000000fac1aa52
 r24-27  0000000000000028 00000000bbbe87b8 00000000bbbe87b8 0000000040d2b1a0
 r28-31  0000000000000000 00000000b8d501c0 00000000b8d501f0 0000000003424000
 sr00-03  0000000000423000 0000000000000000 0000000000000000 0000000000423000
 sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

 IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040c78cf0 0000000040c78cf4
  IIR: 539f00c0    ISR: 0000000000000000  IOR: 0000000000000060
  CPU:        0   CR30: 00000000b8d50000 CR31: 00000000d22345e2
  ORIG_R28: 0000000040250798
  IAOQ[0]: parisc_kprobe_ss_handler+0x58/0x170
  IAOQ[1]: parisc_kprobe_ss_handler+0x5c/0x170
  RP(r2): parisc_kprobe_ss_handler+0x58/0x170
 Backtrace:
  [<0000000040206ff8>] handle_interruption+0x178/0xbb8
 Kernel panic - not syncing: Kernel Fault

Avoid this panic by checking the return value of kprobe_running() and
skip kprobe if none is currently active.

Cc: <stable@vger.kernel.org> # v5.2
Acked-by: Sven Schnelle <svens@stackframe.org>
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/parisc/kernel/kprobes.c
+++ b/arch/parisc/kernel/kprobes.c
@@ -133,6 +133,9 @@ int __kprobes parisc_kprobe_ss_handler(s
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	struct kprobe *p = kprobe_running();
 
+	if (!p)
+		return 0;
+
 	if (regs->iaoq[0] != (unsigned long)p->ainsn.insn+4)
 		return 0;
 


