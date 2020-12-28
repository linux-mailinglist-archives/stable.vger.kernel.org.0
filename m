Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640362E651A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393237AbgL1P5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391131AbgL1NeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E07FB206ED;
        Mon, 28 Dec 2020 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162446;
        bh=4bsiPwCWsX5NqCLv94bD/B+YY8dp9nloPABhBeBSIMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQw4BJC/dnTalQ0M5hwVrwAJWiyM7Xc/yraKh6PQlorq1E1xHGveR3goetlR6D2/X
         CnqxaMv6yW8CeHJH+QXaPLAKq72hyU/J5BirMgqzVz1Ye3ITrHoSWJfmT5bXIuKS0L
         VLcxWGcWwwsyMuRYaQuzHPFK7C7DHp4JKUJst1Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 306/346] powerpc/powernv/memtrace: Fix crashing the kernel when enabling concurrently
Date:   Mon, 28 Dec 2020 13:50:25 +0100
Message-Id: <20201228124934.583283046@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
@@ -33,6 +33,7 @@ struct memtrace_entry {
 	char name[16];
 };
 
+static DEFINE_MUTEX(memtrace_mutex);
 static u64 memtrace_size;
 
 static struct memtrace_entry *memtrace_array;
@@ -294,6 +295,7 @@ static int memtrace_online(void)
 
 static int memtrace_enable_set(void *data, u64 val)
 {
+	int rc = -EAGAIN;
 	u64 bytes;
 
 	/*
@@ -306,25 +308,31 @@ static int memtrace_enable_set(void *dat
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


