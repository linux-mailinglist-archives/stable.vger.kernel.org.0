Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAC2C097C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388715AbgKWNIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732849AbgKWMsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A6D20857;
        Mon, 23 Nov 2020 12:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135713;
        bh=l1t2go9tcU1zGTrAWqXKpcYoUYrr5hWhzCh5095PGXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAFEZGeXt36mXgqJHJ8CPwXp3SKVQqRHUq0YAdsA71XvFwXaFDk35TIIoUK6N7r4q
         1rm5yy2ZNReAcZL1ml857SyzdehsmqorgSbAE4zVFwF4erd7oJR4rsgJx43eMvAu93
         L1ueoTuf10pxVt5Wqx8D48a3jbmQ17HXeX2MtgXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Xu <dxu@dxuuu.xyz>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 168/252] lib/strncpy_from_user.c: Mask out bytes after NUL terminator.
Date:   Mon, 23 Nov 2020 13:21:58 +0100
Message-Id: <20201123121843.698988021@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit 6fa6d28051e9fcaa1570e69648ea13a353a5d218 ]

do_strncpy_from_user() may copy some extra bytes after the NUL
terminator into the destination buffer. This usually does not matter for
normal string operations. However, when BPF programs key BPF maps with
strings, this matters a lot.

A BPF program may read strings from user memory by calling the
bpf_probe_read_user_str() helper which eventually calls
do_strncpy_from_user(). The program can then key a map with the
destination buffer. BPF map keys are fixed-width and string-agnostic,
meaning that map keys are treated as a set of bytes.

The issue is when do_strncpy_from_user() overcopies bytes after the NUL
terminator, it can result in seemingly identical strings occupying
multiple slots in a BPF map. This behavior is subtle and totally
unexpected by the user.

This commit masks out the bytes following the NUL while preserving
long-sized stride in the fast path.

Fixes: 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers")
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/21efc982b3e9f2f7b0379eed642294caaa0c27a7.1605642949.git.dxu@dxuuu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 10 ++++++++++
 lib/strncpy_from_user.c  | 19 +++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a8d4f253ed778..f236927ed2110 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -173,6 +173,16 @@ bpf_probe_read_user_str_common(void *dst, u32 size,
 {
 	int ret;
 
+	/*
+	 * NB: We rely on strncpy_from_user() not copying junk past the NUL
+	 * terminator into `dst`.
+	 *
+	 * strncpy_from_user() does long-sized strides in the fast path. If the
+	 * strncpy does not mask out the bytes after the NUL in `unsafe_ptr`,
+	 * then there could be junk after the NUL in `dst`. If user takes `dst`
+	 * and keys a hash map with it, then semantically identical strings can
+	 * occupy multiple entries in the map.
+	 */
 	ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 		memset(dst, 0, size);
diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 34696a348864f..2eaed320a4db7 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -34,17 +34,32 @@ static inline long do_strncpy_from_user(char *dst, const char __user *src,
 		goto byte_at_a_time;
 
 	while (max >= sizeof(unsigned long)) {
-		unsigned long c, data;
+		unsigned long c, data, mask;
 
 		/* Fall back to byte-at-a-time if we get a page fault */
 		unsafe_get_user(c, (unsigned long __user *)(src+res), byte_at_a_time);
 
-		*(unsigned long *)(dst+res) = c;
+		/*
+		 * Note that we mask out the bytes following the NUL. This is
+		 * important to do because string oblivious code may read past
+		 * the NUL. For those routines, we don't want to give them
+		 * potentially random bytes after the NUL in `src`.
+		 *
+		 * One example of such code is BPF map keys. BPF treats map keys
+		 * as an opaque set of bytes. Without the post-NUL mask, any BPF
+		 * maps keyed by strings returned from strncpy_from_user() may
+		 * have multiple entries for semantically identical strings.
+		 */
 		if (has_zero(c, &data, &constants)) {
 			data = prep_zero_mask(c, data, &constants);
 			data = create_zero_mask(data);
+			mask = zero_bytemask(data);
+			*(unsigned long *)(dst+res) = c & mask;
 			return res + find_zero(data);
 		}
+
+		*(unsigned long *)(dst+res) = c;
+
 		res += sizeof(unsigned long);
 		max -= sizeof(unsigned long);
 	}
-- 
2.27.0



