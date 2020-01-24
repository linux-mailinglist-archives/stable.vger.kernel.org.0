Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2801C1475FB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgAXBRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730325AbgAXBRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324BB206A2;
        Fri, 24 Jan 2020 01:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828633;
        bh=AUJ7Mi/W3UD5YTk3TevtD9PxZSR5axwLwf8CCIlNtWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=So66+xsJYNV9ZT/TEa74XH9MIJc/X7/1A2vWMrEK9jdlObHnQPBy9t/u1xt4YljxF
         EG7GRHBIxgQ9IGKTGqOFneBRRsmRrUImWAyyC4NiEaVBxrbVgBf1jn4d6Zik7PBXjQ
         VP/7xz2tHeL6vOrIlMaiOl8irAfcyAD0o5dB8+HE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/33] libbpf: Fix BTF-defined map's __type macro handling of arrays
Date:   Thu, 23 Jan 2020 20:16:39 -0500
Message-Id: <20200124011708.18232-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

