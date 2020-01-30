Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF3314E181
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgA3SpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730680AbgA3SpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82552082E;
        Thu, 30 Jan 2020 18:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409903;
        bh=AUJ7Mi/W3UD5YTk3TevtD9PxZSR5axwLwf8CCIlNtWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNOrFn9g/dH7nAKhnb8SoC7HmHv0wwYA1WV2e+dSf9XeXRO/l3vjMsOzwUbYveIgR
         vFOVMWnhNdpSlYEa85HlRhs2ztylQm3GcScXcFNqxTE1ELkbKPPMbmxSJkLrYqxkiG
         LUI2S87TSbqMJv1T2uXRxVdLYrF7aIxkSr3lz8Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/110] libbpf: Fix BTF-defined maps __type macro handling of arrays
Date:   Thu, 30 Jan 2020 19:38:54 +0100
Message-Id: <20200130183623.512525712@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit a53ba15d81995868651dd28a85d8045aef3d4e20 ]

Due to a quirky C syntax of declaring pointers to array or function
prototype, existing __type() macro doesn't work with map key/value types
that are array or function prototype. One has to create a typedef first
and use it to specify key/value type for a BPF map.  By using typeof(),
pointer to type is now handled uniformly for all kinds of types. Convert
one of self-tests as a demonstration.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191004040211.2434033-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bpf_helpers.h                | 2 +-
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 54a50699bbfda..9f77cbaac01c1 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -3,7 +3,7 @@
 #define __BPF_HELPERS__
 
 #define __uint(name, val) int (*name)[val]
-#define __type(name, val) val *name
+#define __type(name, val) typeof(val) *name
 
 /* helper macro to print out debug messages */
 #define bpf_printk(fmt, ...)				\
diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index f8ffa3f3d44bb..6cc4479ac9df6 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -47,12 +47,11 @@ struct {
  * issue and avoid complicated C programming massaging.
  * This is an acceptable workaround since there is one entry here.
  */
-typedef __u64 raw_stack_trace_t[2 * MAX_STACK_RAWTP];
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__uint(max_entries, 1);
 	__type(key, __u32);
-	__type(value, raw_stack_trace_t);
+	__type(value, __u64[2 * MAX_STACK_RAWTP]);
 } rawdata_map SEC(".maps");
 
 SEC("raw_tracepoint/sys_enter")
-- 
2.20.1



