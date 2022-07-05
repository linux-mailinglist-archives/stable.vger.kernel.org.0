Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5A6566B56
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiGEMF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiGEMFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0182515FF4;
        Tue,  5 Jul 2022 05:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CD2BB817E1;
        Tue,  5 Jul 2022 12:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7B4C341C7;
        Tue,  5 Jul 2022 12:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022673;
        bh=Xf/Ge2KvjiZb23gT7lk55mqe0xDzPV0YbzEZ/ET/f6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwPkzldNnh4N/kU4ENUzeNwqQvgNWBu9uEhE5p5siXMvHsyu2bS3B1RoNx6pSQCFN
         FWx5XPSTk8fCQc7ERNXB3VoPzQHfpGxlBeYPur4oXKqoeJpV4oIopQVzznlbavR9MF
         o77bXzXW0x4oZ7yp+gXTrMHN7ZMzvjj9gJGNcagI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 04/58] powerpc/bpf: Fix use of user_pt_regs in uapi
Date:   Tue,  5 Jul 2022 13:57:40 +0200
Message-Id: <20220705115610.371818499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit b21bd5a4b130f8370861478d2880985daace5913 upstream.

Trying to build a .c file that includes <linux/bpf_perf_event.h>:
  $ cat test_bpf_headers.c
  #include <linux/bpf_perf_event.h>

throws the below error:
  /usr/include/linux/bpf_perf_event.h:14:28: error: field ‘regs’ has incomplete type
     14 |         bpf_user_pt_regs_t regs;
	|                            ^~~~

This is because we typedef bpf_user_pt_regs_t to 'struct user_pt_regs'
in arch/powerpc/include/uaps/asm/bpf_perf_event.h, but 'struct
user_pt_regs' is not exposed to userspace.

Powerpc has both pt_regs and user_pt_regs structures. However, unlike
arm64 and s390, we expose user_pt_regs to userspace as just 'pt_regs'.
As such, we should typedef bpf_user_pt_regs_t to 'struct pt_regs' for
userspace.

Within the kernel though, we want to typedef bpf_user_pt_regs_t to
'struct user_pt_regs'.

Remove arch/powerpc/include/uapi/asm/bpf_perf_event.h so that the
uapi/asm-generic version of the header is exposed to userspace.
Introduce arch/powerpc/include/asm/bpf_perf_event.h so that we can
typedef bpf_user_pt_regs_t to 'struct user_pt_regs' for use within the
kernel.

Note that this was not showing up with the bpf selftest build since
tools/include/uapi/asm/bpf_perf_event.h didn't include the powerpc
variant.

Fixes: a6460b03f945ee ("powerpc/bpf: Fix broken uapi for BPF_PROG_TYPE_PERF_EVENT")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
[mpe: Use typical naming for header include guard]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220627191119.142867-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/bpf_perf_event.h      |    9 +++++++++
 arch/powerpc/include/uapi/asm/bpf_perf_event.h |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)
 create mode 100644 arch/powerpc/include/asm/bpf_perf_event.h
 delete mode 100644 arch/powerpc/include/uapi/asm/bpf_perf_event.h

--- /dev/null
+++ b/arch/powerpc/include/asm/bpf_perf_event.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_BPF_PERF_EVENT_H
+#define _ASM_POWERPC_BPF_PERF_EVENT_H
+
+#include <asm/ptrace.h>
+
+typedef struct user_pt_regs bpf_user_pt_regs_t;
+
+#endif /* _ASM_POWERPC_BPF_PERF_EVENT_H */
--- a/arch/powerpc/include/uapi/asm/bpf_perf_event.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _UAPI__ASM_BPF_PERF_EVENT_H__
-#define _UAPI__ASM_BPF_PERF_EVENT_H__
-
-#include <asm/ptrace.h>
-
-typedef struct user_pt_regs bpf_user_pt_regs_t;
-
-#endif /* _UAPI__ASM_BPF_PERF_EVENT_H__ */


