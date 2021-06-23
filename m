Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1533B2390
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 00:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhFWW0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 18:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhFWW0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 18:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632F760249;
        Wed, 23 Jun 2021 22:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624487053;
        bh=DiHiiL3b0y6OHvRgx8JkE5k1nddPZ2+efzgAs28XDts=;
        h=Date:From:To:Subject:From;
        b=boP5c1w46q1OIO127mRbmwP6NVF/u3hgGcS70uPh7TidDezUalXzL6Coz6vgQ2P5T
         rlXLbNTSkVlAkABZZGv5UyZnokpGTnZxGafhYlx9VpyXdoyYQxfkUqOcWyLDfYxmLo
         Gzk/F9x8Eq54LT+40L3ZmkKAZGCD0VAhL9bOLqIk=
Date:   Wed, 23 Jun 2021 15:24:12 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, andi@firstfloor.org, dhowells@redhat.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [alternative-merged]
 afs-fix-tracepoint-string-placement-with-built-in-afs.patch removed from
 -mm tree
Message-ID: <20210623222412.CTsmCepgK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: afs: fix tracepoint string placement with built-in AFS
has been removed from the -mm tree.  Its filename was
     afs-fix-tracepoint-string-placement-with-built-in-afs.patch

This patch was dropped because an alternative patch was merged

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

lib-memscan-fixlet.patch
lib-uninline-simple_strtoull.patch
exec-remove-checks-in-__register_bimfmt.patch

