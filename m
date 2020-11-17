Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8872B60B1
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgKQNLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgKQNLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:11:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 405E624199;
        Tue, 17 Nov 2020 13:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618711;
        bh=xTAXFNREFzNiLURv6XXd01JKeNZ3ZXa4zHUHpNhRLEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcgp/ZiAgHQunXzaE5k4cI56XDg5fbNRGqWsDP1U/6GL17q3SoWhPraSFnCNpCLcG
         dMOeUJrBXPIZsnlWc4wEWrrsao/kK51yrjlpIveHNXSkgEZKbdNsmXMnDUzrfwGKl1
         SSHv51Z/dkf5EPGaRK79DPAP+OUQ0iiRzsHFHiwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, acme@kernel.org,
        miklos@szeredi.hu, namhyung@kernel.org, songliubraving@fb.com,
        Ingo Molnar <mingo@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 60/78] perf/core: Fix crash when using HW tracing kernel filters
Date:   Tue, 17 Nov 2020 14:05:26 +0100
Message-Id: <20201117122112.038248140@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

commit 7f635ff187ab6be0b350b3ec06791e376af238ab upstream

In function perf_event_parse_addr_filter(), the path::dentry of each struct
perf_addr_filter is left unassigned (as it should be) when the pattern
being parsed is related to kernel space.  But in function
perf_addr_filter_match() the same dentries are given to d_inode() where
the value is not expected to be NULL, resulting in the following splat:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000058
  pc : perf_event_mmap+0x2fc/0x5a0
  lr : perf_event_mmap+0x2c8/0x5a0
  Process uname (pid: 2860, stack limit = 0x000000001cbcca37)
  Call trace:
   perf_event_mmap+0x2fc/0x5a0
   mmap_region+0x124/0x570
   do_mmap+0x344/0x4f8
   vm_mmap_pgoff+0xe4/0x110
   vm_mmap+0x2c/0x40
   elf_map+0x60/0x108
   load_elf_binary+0x450/0x12c4
   search_binary_handler+0x90/0x290
   __do_execve_file.isra.13+0x6e4/0x858
   sys_execve+0x3c/0x50
   el0_svc_naked+0x30/0x34

This patch is fixing the problem by introducing a new check in function
perf_addr_filter_match() to see if the filter's dentry is NULL.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: acme@kernel.org
Cc: miklos@szeredi.hu
Cc: namhyung@kernel.org
Cc: songliubraving@fb.com
Fixes: 9511bce9fe8e ("perf/core: Fix bad use of igrab()")
Link: http://lkml.kernel.org/r/1531782831-1186-1-git-send-email-mathieu.poirier@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6814,6 +6814,10 @@ static bool perf_addr_filter_match(struc
 				     struct file *file, unsigned long offset,
 				     unsigned long size)
 {
+	/* d_inode(NULL) won't be equal to any mapped user-space file */
+	if (!filter->path.dentry)
+		return false;
+
 	if (d_inode(filter->path.dentry) != file_inode(file))
 		return false;
 


