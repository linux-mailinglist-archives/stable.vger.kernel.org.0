Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE1D3A72A1
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 01:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFNXuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 19:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhFNXuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 19:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF6F261378;
        Mon, 14 Jun 2021 23:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623714482;
        bh=CaC7fgf5Kx+DeOX3abSOWFT971MQssUAMC9OlBeh9kM=;
        h=Date:From:To:Subject:From;
        b=nDN0jKSl9qIIuVYk9I6c69GiM6JgJWejsZFui5BIWBu0CRJB/pBxTDK/iavcDVSDA
         w1wB824D990EVj6zQC5X0PnJKddiYCVhrzkhJZSCZJJtet4qU79ap6HZmuZG98IRMh
         dOCwlFjsx4v8mMo5kFvB3s/+B2/8Q0PJNfns/vx4=
Date:   Mon, 14 Jun 2021 16:48:02 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, andi@firstfloor.org, dhowells@redhat.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 afs-fix-tracepoint-string-placement-with-built-in-afs.patch added to -mm
 tree
Message-ID: <20210614234802.sTWMIG-eE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: afs: fix tracepoint string placement with built-in AFS
has been added to the -mm tree.  Its filename is
     afs-fix-tracepoint-string-placement-with-built-in-afs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/afs-fix-tracepoint-string-placement-with-built-in-afs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/afs-fix-tracepoint-string-placement-with-built-in-afs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: afs: fix tracepoint string placement with built-in AFS

I was adding custom tracepoint to the kernel, grabbed full F34 kernel
.config, disabled modules and booted whole shebang as VM kernel.

Then did

	perf record -a -e ...

It crashed:

	general protection fault, probably for non-canonical address 0x435f5346592e4243: 0000 [#1] SMP PTI
	CPU: 1 PID: 842 Comm: cat Not tainted 5.12.6+ #26
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
	RIP: 0010:t_show+0x22/0xd0

Then reproducer was narrowed to

	# cat /sys/kernel/tracing/printk_formats

Original F34 kernel with modules didn't crash.

So I started to disable options and after disabling AFS everything started
working again.

The root cause is that AFS was placing char arrays content into a section
full of _pointers_ to strings with predictable consequences.

Non canonical address 435f5346592e4243 is "CB.YFS_" which came from
CM_NAME macro.

The fix is to create char array and pointer to it separatedly.

Steps to reproduce:

	CONFIG_AFS=y
	CONFIG_TRACING=y

	# cat /sys/kernel/tracing/printk_formats

Link: https://lkml.kernel.org/r/YLAXfvZ+rObEOdc/@localhost.localdomain
Fixes: 8e8d7f13b6d5a9 ("afs: Add some tracepoints")
Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/cmservice.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/afs/cmservice.c~afs-fix-tracepoint-string-placement-with-built-in-afs
+++ a/fs/afs/cmservice.c
@@ -30,8 +30,9 @@ static void SRXAFSCB_TellMeAboutYourself
 static int afs_deliver_yfs_cb_callback(struct afs_call *);
 
 #define CM_NAME(name) \
-	char afs_SRXCB##name##_name[] __tracepoint_string =	\
-		"CB." #name
+	const char afs_SRXCB##name##_name[] = "CB." #name;		\
+	static const char *_afs_SRXCB##name##_name __tracepoint_string =\
+		afs_SRXCB##name##_name
 
 /*
  * CB.CallBack operation type
_

Patches currently in -mm which might be from adobriyan@gmail.com are

afs-fix-tracepoint-string-placement-with-built-in-afs.patch
lib-memscan-fixlet.patch
lib-uninline-simple_strtoull.patch
exec-remove-checks-in-__register_bimfmt.patch

