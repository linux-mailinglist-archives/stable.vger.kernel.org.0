Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860E62E42D3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406788AbgL1N47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407634AbgL1N4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2842B206D4;
        Mon, 28 Dec 2020 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163728;
        bh=tKqsXdFU/NeplTA1uxAAQHyltAEXFIkAEkoqLe0Zp2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7xotaSCV0t56YpzONBb7MTOdnMuwH4gESIF7cgKbm60oU63dde8EDjq7illbJtSi
         8xCmPae1wPcCioRR6GeSOvhCa8RftEaKRXBpkOBzSXeGtyElD/24hJ8yrtn+zUS4rO
         Ld9m9csjFOAUjCowE1bC2E6ieDSIH0vVG558kLJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 388/453] powerpc/powernv/memtrace: Fix crashing the kernel when enabling concurrently
Date:   Mon, 28 Dec 2020 13:50:24 +0100
Message-Id: <20201228124955.874536718@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit d6718941a2767fb383e105d257d2105fe4f15f0e upstream.

It's very easy to crash the kernel right now by simply trying to
enable memtrace concurrently, hammering on the "enable" interface

loop.sh:
  #!/bin/bash

  dmesg --console-off

  while true; do
          echo 0x40000000 > /sys/kernel/debug/powerpc/memtrace/enable
  done

[root@localhost ~]# loop.sh &
[root@localhost ~]# loop.sh &

Resulting quickly in a kernel crash. Let's properly protect using a
mutex.

Fixes: 9d5171a8f248 ("powerpc/powernv: Enable removal of memory for in memory tracing")
Cc: stable@vger.kernel.org# v4.14+
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201111145322.15793-3-david@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/memtrace.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -30,6 +30,7 @@ struct memtrace_entry {
 	char name[16];
 };
 
+static DEFINE_MUTEX(memtrace_mutex);
 static u64 memtrace_size;
 
 static struct memtrace_entry *memtrace_array;
@@ -290,6 +291,7 @@ static int memtrace_online(void)
 
 static int memtrace_enable_set(void *data, u64 val)
 {
+	int rc = -EAGAIN;
 	u64 bytes;
 
 	/*
@@ -302,25 +304,31 @@ static int memtrace_enable_set(void *dat
 		return -EINVAL;
 	}
 
+	mutex_lock(&memtrace_mutex);
+
 	/* Re-add/online previously removed/offlined memory */
 	if (memtrace_size) {
 		if (memtrace_online())
-			return -EAGAIN;
+			goto out_unlock;
 	}
 
-	if (!val)
-		return 0;
+	if (!val) {
+		rc = 0;
+		goto out_unlock;
+	}
 
 	/* Offline and remove memory */
 	if (memtrace_init_regions_runtime(val))
-		return -EINVAL;
+		goto out_unlock;
 
 	if (memtrace_init_debugfs())
-		return -EINVAL;
+		goto out_unlock;
 
 	memtrace_size = val;
-
-	return 0;
+	rc = 0;
+out_unlock:
+	mutex_unlock(&memtrace_mutex);
+	return rc;
 }
 
 static int memtrace_enable_get(void *data, u64 *val)


