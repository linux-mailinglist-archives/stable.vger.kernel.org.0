Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B250A8F65
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387986AbfIDSDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387960AbfIDSDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:03:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFD92339E;
        Wed,  4 Sep 2019 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620203;
        bh=b+rBF7V5rIqgAolUvI7hLO0r5ZRszQitsSUesKsGlZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oX6k8AYZcL/NseSQoPmfPGMsC+sYzSaFAXmDkEWxWsaHav24CebxRw0LRHng5zcJh
         NoeNGAC7sGIsAT0NgM9bJin2S04mSuKQoZBd/KLY7XIKPEXcnMWAVjugVSf+PNHVQW
         Du/YN+AavzOh5w47bKN1fIW7+qVm7mSOZ0QaZKZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 28/57] ftrace: Fix NULL pointer dereference in t_probe_next()
Date:   Wed,  4 Sep 2019 19:53:56 +0200
Message-Id: <20190904175304.700046585@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 7bd46644ea0f6021dc396a39a8bfd3a58f6f1f9f upstream.

LTP testsuite on powerpc results in the below crash:

  Unable to handle kernel paging request for data at address 0x00000000
  Faulting instruction address: 0xc00000000029d800
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE SMP NR_CPUS=2048 NUMA PowerNV
  ...
  CPU: 68 PID: 96584 Comm: cat Kdump: loaded Tainted: G        W
  NIP:  c00000000029d800 LR: c00000000029dac4 CTR: c0000000001e6ad0
  REGS: c0002017fae8ba10 TRAP: 0300   Tainted: G        W
  MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 28022422  XER: 20040000
  CFAR: c00000000029d90c DAR: 0000000000000000 DSISR: 40000000 IRQMASK: 0
  ...
  NIP [c00000000029d800] t_probe_next+0x60/0x180
  LR [c00000000029dac4] t_mod_start+0x1a4/0x1f0
  Call Trace:
  [c0002017fae8bc90] [c000000000cdbc40] _cond_resched+0x10/0xb0 (unreliable)
  [c0002017fae8bce0] [c0000000002a15b0] t_start+0xf0/0x1c0
  [c0002017fae8bd30] [c0000000004ec2b4] seq_read+0x184/0x640
  [c0002017fae8bdd0] [c0000000004a57bc] sys_read+0x10c/0x300
  [c0002017fae8be30] [c00000000000b388] system_call+0x5c/0x70

The test (ftrace_set_ftrace_filter.sh) is part of ftrace stress tests
and the crash happens when the test does 'cat
$TRACING_PATH/set_ftrace_filter'.

The address points to the second line below, in t_probe_next(), where
filter_hash is dereferenced:
  hash = iter->probe->ops.func_hash->filter_hash;
  size = 1 << hash->size_bits;

This happens due to a race with register_ftrace_function_probe(). A new
ftrace_func_probe is created and added into the func_probes list in
trace_array under ftrace_lock. However, before initializing the filter,
we drop ftrace_lock, and re-acquire it after acquiring regex_lock. If
another process is trying to read set_ftrace_filter, it will be able to
acquire ftrace_lock during this window and it will end up seeing a NULL
filter_hash.

Fix this by just checking for a NULL filter_hash in t_probe_next(). If
the filter_hash is NULL, then this probe is just being added and we can
simply return from here.

Link: http://lkml.kernel.org/r/05e021f757625cbbb006fad41380323dbe4e3b43.1562249521.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Fixes: 7b60f3d876156 ("ftrace: Dynamically create the probe ftrace_ops for the trace_array")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3184,6 +3184,10 @@ t_probe_next(struct seq_file *m, loff_t
 		hnd = &iter->probe_entry->hlist;
 
 	hash = iter->probe->ops.func_hash->filter_hash;
+
+	if (!hash)
+		return NULL;
+
 	size = 1 << hash->size_bits;
 
  retry:


