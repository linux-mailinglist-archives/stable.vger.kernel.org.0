Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D481F132746
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 14:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgAGNKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 08:10:51 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42575 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbgAGNKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 08:10:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9E2E260D;
        Tue,  7 Jan 2020 08:10:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 07 Jan 2020 08:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DhlhVE
        UDxbp5U+fn9vtDDxNm0qncgdx3AKCKY5sj+Gw=; b=wvCIodBQwg7ZXzSOrKuWqc
        k+2nyu9LvaWBwcn5PGNQoXiIokPdH7Plwwx9ByIVvOfRHdaDARRY8QRNAPyYNP/v
        BmHOoLOL8xu0CJufwm/8WxQ41bL4IQWuVEhbbTOrZB0SddZKbkBwMhbjzOIRpJCn
        b/10ajKosXyK2EMDTnSbtg2gifgxUE0+IBhaKM32EBREMqyv6vXHYUdAIsWOimQV
        8uKrdXs1/hpSG/xUiDY0w0vtzbZOCsvVMyc9qiHlPks6GD8XFMNl34eFLf90T4f7
        8KmWNXOZymxsYVQkC0KqIwHQsMUF2y9PcDFZfsG0Rb8sIK/xhC6DB0YXfTv10SKw
        ==
X-ME-Sender: <xms:WIMUXvZsD4LvmHa_DoFIg22uyh7TIwn3MCtc6EDhwWmOFy2mcWvBGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:WIMUXr2uGFYwj1EKogZh5hfpsJAS7GcjpWMh-TdpnuRqwU6HvLN23w>
    <xmx:WIMUXh7wDPD31_AgM6-fohmwmhgKP5uS0UM6mO6fRj2I-Cbi7qFuNw>
    <xmx:WIMUXnTJKZ8kUPzHbYdtUdjzJenKAGkXVu6r3pgR4RndH5TajzBYsQ>
    <xmx:WYMUXkNhLqMmryj0QD4G-IpEx71AxQlfXu0oI9wREkwOzt8uQAaP8Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0174E8005A;
        Tue,  7 Jan 2020 08:10:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Chunk calls to flush_dcache_range in arch_*_memory" failed to apply to 4.14-stable tree
To:     alastair@d-silva.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jan 2020 14:10:46 +0100
Message-ID: <15784026468315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 076265907cf9633bbef861c7c2a1c26a8209f283 Mon Sep 17 00:00:00 2001
From: Alastair D'Silva <alastair@d-silva.org>
Date: Mon, 4 Nov 2019 13:32:57 +1100
Subject: [PATCH] powerpc: Chunk calls to flush_dcache_range in arch_*_memory

When presented with large amounts of memory being hotplugged
(in my test case, ~890GB), the call to flush_dcache_range takes
a while (~50 seconds), triggering RCU stalls.

This patch breaks up the call into 1GB chunks, calling
cond_resched() inbetween to allow the scheduler to run.

Fixes: fb5924fddf9e ("powerpc/mm: Flush cache on memory hot(un)plug")
Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191104023305.9581-6-alastair@au1.ibm.com

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 3392cacabe60..634e5ea55b6b 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -104,6 +104,27 @@ int __weak remove_section_mapping(unsigned long start, unsigned long end)
 	return -ENODEV;
 }
 
+#define FLUSH_CHUNK_SIZE SZ_1G
+/**
+ * flush_dcache_range_chunked(): Write any modified data cache blocks out to
+ * memory and invalidate them, in chunks of up to FLUSH_CHUNK_SIZE
+ * Does not invalidate the corresponding instruction cache blocks.
+ *
+ * @start: the start address
+ * @stop: the stop address (exclusive)
+ * @chunk: the max size of the chunks
+ */
+static void flush_dcache_range_chunked(unsigned long start, unsigned long stop,
+				       unsigned long chunk)
+{
+	unsigned long i;
+
+	for (i = start; i < stop; i += chunk) {
+		flush_dcache_range(i, min(stop, start + chunk));
+		cond_resched();
+	}
+}
+
 int __ref arch_add_memory(int nid, u64 start, u64 size,
 			struct mhp_restrictions *restrictions)
 {
@@ -120,7 +141,8 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 			start, start + size, rc);
 		return -EFAULT;
 	}
-	flush_dcache_range(start, start + size);
+
+	flush_dcache_range_chunked(start, start + size, FLUSH_CHUNK_SIZE);
 
 	return __add_pages(nid, start_pfn, nr_pages, restrictions);
 }
@@ -137,7 +159,8 @@ void __ref arch_remove_memory(int nid, u64 start, u64 size,
 
 	/* Remove htab bolted mappings for this section of memory */
 	start = (unsigned long)__va(start);
-	flush_dcache_range(start, start + size);
+	flush_dcache_range_chunked(start, start + size, FLUSH_CHUNK_SIZE);
+
 	ret = remove_section_mapping(start, start + size);
 	WARN_ON_ONCE(ret);
 

