Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBAB6DBCFF
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 22:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDHUtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 16:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHUtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 16:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308F17D90;
        Sat,  8 Apr 2023 13:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C05F660AC1;
        Sat,  8 Apr 2023 20:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2419FC433EF;
        Sat,  8 Apr 2023 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680986946;
        bh=dsDHteCIgBQ2FJqeZyvejZHKBHJc3D6BH6VHQHSM5fA=;
        h=Date:To:From:Subject:From;
        b=IrEEhA8zJFYJI4v6+ZxZspCtXJ04QD3U32rNYAtEjgMqNp291KgdRAVbcdXsLFu3W
         cDX5Hntb1F14qq67ho89sACjdLMVlTWdQizA5HyuxAIprHIZdif3iULY5jh3j4o4IG
         J3HUQc/xMz1a45lhC8wyfTV4/XJUxKAFiXyuCQgI=
Date:   Sat, 08 Apr 2023 13:49:05 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        kbingham@kernel.org, jan.kiszka@siemens.com, f.fainelli@gmail.com,
        liupeng17@lenovo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-timerlist-for-python3.patch added to mm-nonmm-unstable branch
Message-Id: <20230408204906.2419FC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-timerlist for Python3
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-lx-timerlist-for-python3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-timerlist-for-python3.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peng Liu <liupeng17@lenovo.com>
Subject: scripts/gdb: fix lx-timerlist for Python3
Date: Tue, 21 Mar 2023 14:19:29 +0800

Below incompatibilities between Python2 and Python3 made lx-timerlist fail
to run under Python3.

o xrange() is replaced by range() in Python3
o bytes and str are different types in Python3
o the return value of Inferior.read_memory() is memoryview object in
  Python3

akpm: cc stable so that older kernels are properly debuggable under newer
Python.

Link: https://lkml.kernel.org/r/TYCP286MB2146EE1180A4D5176CBA8AB2C6819@TYCP286MB2146.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |    4 +++-
 scripts/gdb/linux/utils.py     |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-fix-lx-timerlist-for-python3
+++ a/scripts/gdb/linux/timerlist.py
@@ -72,7 +72,7 @@ def print_cpu(hrtimer_bases, cpu, max_cl
     ts = cpus.per_cpu(tick_sched_ptr, cpu)
 
     text = "cpu: {}\n".format(cpu)
-    for i in xrange(max_clock_bases):
+    for i in range(max_clock_bases):
         text += " clock {}:\n".format(i)
         text += print_base(cpu_base['clock_base'][i])
 
@@ -157,6 +157,8 @@ def pr_cpumask(mask):
     num_bytes = (nr_cpu_ids + 7) / 8
     buf = utils.read_memoryview(inf, bits, num_bytes).tobytes()
     buf = binascii.b2a_hex(buf)
+    if type(buf) is not str:
+        buf=buf.decode()
 
     chunks = []
     i = num_bytes
--- a/scripts/gdb/linux/utils.py~scripts-gdb-fix-lx-timerlist-for-python3
+++ a/scripts/gdb/linux/utils.py
@@ -88,7 +88,10 @@ def get_target_endianness():
 
 
 def read_memoryview(inf, start, length):
-    return memoryview(inf.read_memory(start, length))
+    m = inf.read_memory(start, length)
+    if type(m) is memoryview:
+        return m
+    return memoryview(m)
 
 
 def read_u16(buffer, offset):
_

Patches currently in -mm which might be from liupeng17@lenovo.com are

scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch
scripts-gdb-fix-lx-timerlist-for-python3.patch
scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch

