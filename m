Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB67B34CE60
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 13:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhC2LAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 07:00:19 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58887 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbhC2LAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 07:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617015608; x=1648551608;
  h=subject:from:to:references:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=Jmwut4pNd2qcHKTC3t/jU+8PC/rMX61Q5T/ETAKAAIc=;
  b=oksIJflSHSdXeb++/eQh3IY57I95kd0SydFoqXl98/Qv/48ZmBsUcmCm
   YV8/u3HXzj6mbE02rMGXki34u/qnxR7KJmAV85Sut7MH11u/DdQYnge+L
   mMkQq3XSoXhPy9AIpmIy6E8YogcPPXcmYxUrAzyLHWsJ8pc6qK+fvou9h
   0=;
X-IronPort-AV: E=Sophos;i="5.81,287,1610409600"; 
   d="scan'208";a="101588277"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 Mar 2021 10:59:56 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id 845AEA8901
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 10:59:55 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.160.224) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 29 Mar 2021 10:59:53 +0000
Subject: [PATCH 2/2] tracing/kprobes: handle userspace access on unified
 probes
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
Message-ID: <ea2d7cd2-9891-573e-ebcb-bfeebd79661a@amazon.com>
Date:   Mon, 29 Mar 2021 13:59:48 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.224]
X-ClientProxiedBy: EX13D06UWA004.ant.amazon.com (10.43.160.164) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit 9de1fec50b23117f0a19f7609cc837ca72e764a6 upstream.

This is an adaptation of parts from the above commit to kernel 5.4.

Allow Kprobes to access userspace data correctly in architectures with no
overlap between kernel and userspace addresses.

Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 kernel/trace/trace_kprobe.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 233322c77b76..cbd72a1c9530 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1043,6 +1043,11 @@ fetch_store_strlen(unsigned long addr)
     int ret, len = 0;
     u8 c;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+    if (addr < TASK_SIZE)
+        return fetch_store_strlen_user(addr);
+#endif
+
     do {
         ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
         len++;
@@ -1071,6 +1076,11 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
     void *__dest;
     long ret;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+    if (addr < TASK_SIZE)
+        return fetch_store_string_user(addr, dest, base);
+#endif
+
     if (unlikely(!maxlen))
         return -ENOMEM;
 
@@ -1114,6 +1124,11 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
 static nokprobe_inline int
 probe_mem_read(void *dest, void *src, size_t size)
 {
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+    if ((unsigned long)src < TASK_SIZE)
+        return probe_mem_read_user(dest, src, size);
+#endif
+
     return probe_kernel_read(dest, src, size);
 }
 
-- 
2.25.1


