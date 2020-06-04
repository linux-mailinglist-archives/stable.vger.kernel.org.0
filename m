Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1451EEE85
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 01:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgFDXv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 19:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 19:51:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17525208C9;
        Thu,  4 Jun 2020 23:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591314688;
        bh=XXxDjNogkdci1qxWAScTv1ZqBxr4iB4zXBQkWdZw69M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vesZObfp4RqYwVGtUJeAWJ+QymivPs2gRGxL1edqN+Y07VpVZ8iPKXG6lv9f7XUPQ
         xmatokQ6oMIf6zSl4aQAIhldR1Q3KaSHxiCsr53vbkbcgDjV0FpZ+pqTB0s8qrt4b4
         tw2H0enK/t+YWLkZ0uZ+vukdFOUMXEzMn6RxYRQY=
Date:   Thu, 04 Jun 2020 16:51:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ajd@linux.ibm.com, akash.goel@intel.com, akpm@linux-foundation.org,
        carnil@debian.org, dja@axtens.net, linux-mm@kvack.org,
        linux@roeck-us.net, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 100/127] kernel/relay.c: handle alloc_percpu
 returning NULL in relay_open
Message-ID: <20200604235127.XZqAyQULA%akpm@linux-foundation.org>
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>
Subject: kernel/relay.c: handle alloc_percpu returning NULL in relay_open

alloc_percpu() may return NULL, which means chan->buf may be set to NULL. 
In that case, when we do *per_cpu_ptr(chan->buf, ...), we dereference an
invalid pointer:

BUG: Unable to handle kernel data access at 0x7dae0000
Faulting instruction address: 0xc0000000003f3fec
...
NIP [c0000000003f3fec] relay_open+0x29c/0x600
LR [c0000000003f3fc0] relay_open+0x270/0x600
Call Trace:
[c000000054353a70] [c0000000003f3fb4] relay_open+0x264/0x600 (unreliable)
[c000000054353b00] [c000000000451764] __blk_trace_setup+0x254/0x600
[c000000054353bb0] [c000000000451b78] blk_trace_setup+0x68/0xa0
[c000000054353c10] [c0000000010da77c] sg_ioctl+0x7bc/0x2e80
[c000000054353cd0] [c000000000758cbc] do_vfs_ioctl+0x13c/0x1300
[c000000054353d90] [c000000000759f14] ksys_ioctl+0x94/0x130
[c000000054353de0] [c000000000759ff8] sys_ioctl+0x48/0xb0
[c000000054353e20] [c00000000000bcd0] system_call+0x5c/0x68

Check if alloc_percpu returns NULL.

This was found by syzkaller both on x86 and powerpc, and the reproducer it
found on powerpc is capable of hitting the issue as an unprivileged user.

Link: http://lkml.kernel.org/r/20191219121256.26480-1-dja@axtens.net
Fixes: 017c59c042d0 ("relay: Use per CPU constructs for the relay channel buffer pointers")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Reported-by: syzbot+1e925b4b836afe85a1c6@syzkaller-ppc64.appspotmail.com
Reported-by: syzbot+587b2421926808309d21@syzkaller-ppc64.appspotmail.com
Reported-by: syzbot+58320b7171734bf79d26@syzkaller.appspotmail.com
Reported-by: syzbot+d6074fb08bdb2e010520@syzkaller.appspotmail.com
Cc: Akash Goel <akash.goel@intel.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: <stable@vger.kernel.org>	[4.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/relay.c~relay-handle-alloc_percpu-returning-null-in-relay_open
+++ a/kernel/relay.c
@@ -581,6 +581,11 @@ struct rchan *relay_open(const char *bas
 		return NULL;
 
 	chan->buf = alloc_percpu(struct rchan_buf *);
+	if (!chan->buf) {
+		kfree(chan);
+		return NULL;
+	}
+
 	chan->version = RELAYFS_CHANNEL_VERSION;
 	chan->n_subbufs = n_subbufs;
 	chan->subbuf_size = subbuf_size;
_
