Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DD9408F6D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbhIMNmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241689AbhIMNkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:40:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B8D661401;
        Mon, 13 Sep 2021 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539771;
        bh=lt2d/6xG79Pm5RiHOz0sUo5GqEsJxbZVv/fJEDxiuOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kv6chbJYumCaITM9yspy/DDBdQzn8m6fI4Q/A5OQrOH6Vcqq4jq6fcllIic9+orei
         4R9a7wCNBJoANsR5Kj030m6KRzTE3euKmBDfCykpe+6ZcFzE2fvz8zChGeTU9NBnod
         Je7ZDm6A0kvGfghxhAjeIVhqKDmobFxu6zVGLn3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/236] selftests/bpf: Fix test_core_autosize on big-endian machines
Date:   Mon, 13 Sep 2021 15:14:19 +0200
Message-Id: <20210913131105.611298619@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit d164dd9a5c08c16a883b3de97d13948c7be7fa4d ]

The "probed" part of test_core_autosize copies an integer using
bpf_core_read() into an integer of a potentially different size.
On big-endian machines a destination offset is required for this to
produce a sensible result.

Fixes: 888d83b961f6 ("selftests/bpf: Validate libbpf's auto-sizing of LD/ST/STX instructions")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210812224814.187460-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/test_core_autosize.c  | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_core_autosize.c b/tools/testing/selftests/bpf/progs/test_core_autosize.c
index 44f5aa2e8956..9a7829c5e4a7 100644
--- a/tools/testing/selftests/bpf/progs/test_core_autosize.c
+++ b/tools/testing/selftests/bpf/progs/test_core_autosize.c
@@ -125,6 +125,16 @@ int handle_downsize(void *ctx)
 	return 0;
 }
 
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define bpf_core_read_int bpf_core_read
+#else
+#define bpf_core_read_int(dst, sz, src) ({ \
+	/* Prevent "subtraction from stack pointer prohibited" */ \
+	volatile long __off = sizeof(*dst) - (sz); \
+	bpf_core_read((char *)(dst) + __off, sz, src); \
+})
+#endif
+
 SEC("raw_tp/sys_enter")
 int handle_probed(void *ctx)
 {
@@ -132,23 +142,23 @@ int handle_probed(void *ctx)
 	__u64 tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->ptr), &in->ptr);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->ptr), &in->ptr);
 	ptr_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val1), &in->val1);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val1), &in->val1);
 	val1_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val2), &in->val2);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val2), &in->val2);
 	val2_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val3), &in->val3);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val3), &in->val3);
 	val3_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val4), &in->val4);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val4), &in->val4);
 	val4_probed = tmp;
 
 	return 0;
-- 
2.30.2



