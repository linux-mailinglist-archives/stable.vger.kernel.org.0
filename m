Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1DA2E67DB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633629AbgL1Q3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbgL1NHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10FF1208B6;
        Mon, 28 Dec 2020 13:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160813;
        bh=prpfV/7K5WxJDZkiaCAbTfjnEQzp7qDjT+B6Bxk0+rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNKdrzMIEU+bTNJGu2zC71elGLd8O4rVivMuWwUCgIqfBOuOaaEmcwNlCU1wgs/F5
         wcNgyU8bc5DDbW5W0+34JnRiJYLwEPTou76mRpDUEJsxw/8v4jlGz4dOu+PjMYFiKX
         c9jPldfr4Hxd+ioAk1awOd0Vt0SlJzuvF2TeAmN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 157/175] powerpc/xmon: Change printk() to pr_cont()
Date:   Mon, 28 Dec 2020 13:50:10 +0100
Message-Id: <20201228124900.850183967@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 7c6c86b36a36dd4a13d30bba07718e767aa2e7a1 upstream.

Since some time now, printk() adds carriage return, leading to
unusable xmon output if there is no udbg backend available:

  [   54.288722] sysrq: Entering xmon
  [   54.292209] Vector: 0  at [cace3d2c]
  [   54.292274]     pc:
  [   54.292331] c0023650
  [   54.292468] : xmon+0x28/0x58
  [   54.292519]
  [   54.292574]     lr:
  [   54.292630] c0023724
  [   54.292749] : sysrq_handle_xmon+0xa4/0xfc
  [   54.292801]
  [   54.292867]     sp: cace3de8
  [   54.292931]    msr: 9032
  [   54.292999]   current = 0xc28d0000
  [   54.293072]     pid   = 377, comm = sh
  [   54.293157] Linux version 5.10.0-rc6-s3k-dev-01364-gedf13f0ccd76-dirty (root@po17688vm.idsi0.si.c-s.fr) (powerpc64-linux-gcc (GCC) 10.1.0, GNU ld (GNU Binutils) 2.34) #4211 PREEMPT Fri Dec 4 09:32:11 UTC 2020
  [   54.293287] enter ? for help
  [   54.293470] [cace3de8]
  [   54.293532] c0023724
  [   54.293654]  sysrq_handle_xmon+0xa4/0xfc
  [   54.293711]  (unreliable)
  ...
  [   54.296002]
  [   54.296159] --- Exception: c01 (System Call) at
  [   54.296217] 0fd4e784
  [   54.296303]
  [   54.296375] SP (7fca6ff0) is in userspace
  [   54.296431] mon>
  [   54.296484]  <no input ...>

Use pr_cont() instead.

Fixes: 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")
Cc: stable@vger.kernel.org # v4.9+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Mention that it only happens when udbg is not available]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c8a6ec704416ecd5ff2bd26213c9bc026bdd19de.1607077340.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/xmon/nonstdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/xmon/nonstdio.c
+++ b/arch/powerpc/xmon/nonstdio.c
@@ -182,7 +182,7 @@ void xmon_printf(const char *format, ...
 
 	if (n && rc == 0) {
 		/* No udbg hooks, fallback to printk() - dangerous */
-		printk("%s", xmon_outbuf);
+		pr_cont("%s", xmon_outbuf);
 	}
 }
 


