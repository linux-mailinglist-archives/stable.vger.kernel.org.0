Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF97C10BD17
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfK0VBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730867AbfK0VBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E772086A;
        Wed, 27 Nov 2019 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888479;
        bh=OmucJeCPDCGQ4KJQdNoOups+FjrbZGAMWJBEPJPyrxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLFITURcF+zl30gPss7Pfi8b6U4x8qE/oofFWJah62a8HGYcy6AV3xYGQd983yRUp
         xTEXSB7hhZtEFL8ixDHG8GzA1iZxEs5Wma2To/EFUli50b5xW2SOTjLw7yGR8ZLMkw
         hpKF+6J2CXkMskUT18HMNMV86geW9eIbFeroPyAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH 4.19 143/306] bpf, btf: fix a missing check bug in btf_parse
Date:   Wed, 27 Nov 2019 21:29:53 +0100
Message-Id: <20191127203125.821842416@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Lau <kafai@fb.com>

[ Upstream commit 4a6998aff82a20a1aece86a186d8e5263f8b2315 ]

Wenwen Wang reported:

  In btf_parse(), the header of the user-space btf data 'btf_data'
  is firstly parsed and verified through btf_parse_hdr().
  In btf_parse_hdr(), the header is copied from user-space 'btf_data'
  to kernel-space 'btf->hdr' and then verified. If no error happens
  during the verification process, the whole data of 'btf_data',
  including the header, is then copied to 'data' in btf_parse(). It
  is obvious that the header is copied twice here. More importantly,
  no check is enforced after the second copy to make sure the headers
  obtained in these two copies are same. Given that 'btf_data' resides
  in the user space, a malicious user can race to modify the header
  between these two copies. By doing so, the user can inject
  inconsistent data, which can cause undefined behavior of the
  kernel and introduce potential security risk.

This issue is similar to the one fixed in commit 8af03d1ae2e1 ("bpf:
btf: Fix a missing check bug"). To fix it, this patch copies the user
'btf_data' *before* parsing / verifying the BTF header.

Fixes: 69b693f0aefa ("bpf: btf: Introduce BPF Type Format (BTF)")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Co-developed-by: Wenwen Wang <wang6495@umn.edu>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 55 ++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 378cef70341c4..cfa27b7d1168c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2067,50 +2067,44 @@ static int btf_check_sec_info(struct btf_verifier_env *env,
 	return 0;
 }
 
-static int btf_parse_hdr(struct btf_verifier_env *env, void __user *btf_data,
-			 u32 btf_data_size)
+static int btf_parse_hdr(struct btf_verifier_env *env)
 {
+	u32 hdr_len, hdr_copy, btf_data_size;
 	const struct btf_header *hdr;
-	u32 hdr_len, hdr_copy;
-	/*
-	 * Minimal part of the "struct btf_header" that
-	 * contains the hdr_len.
-	 */
-	struct btf_min_header {
-		u16	magic;
-		u8	version;
-		u8	flags;
-		u32	hdr_len;
-	} __user *min_hdr;
 	struct btf *btf;
 	int err;
 
 	btf = env->btf;
-	min_hdr = btf_data;
+	btf_data_size = btf->data_size;
 
-	if (btf_data_size < sizeof(*min_hdr)) {
+	if (btf_data_size <
+	    offsetof(struct btf_header, hdr_len) + sizeof(hdr->hdr_len)) {
 		btf_verifier_log(env, "hdr_len not found");
 		return -EINVAL;
 	}
 
-	if (get_user(hdr_len, &min_hdr->hdr_len))
-		return -EFAULT;
-
+	hdr = btf->data;
+	hdr_len = hdr->hdr_len;
 	if (btf_data_size < hdr_len) {
 		btf_verifier_log(env, "btf_header not found");
 		return -EINVAL;
 	}
 
-	err = bpf_check_uarg_tail_zero(btf_data, sizeof(btf->hdr), hdr_len);
-	if (err) {
-		if (err == -E2BIG)
-			btf_verifier_log(env, "Unsupported btf_header");
-		return err;
+	/* Ensure the unsupported header fields are zero */
+	if (hdr_len > sizeof(btf->hdr)) {
+		u8 *expected_zero = btf->data + sizeof(btf->hdr);
+		u8 *end = btf->data + hdr_len;
+
+		for (; expected_zero < end; expected_zero++) {
+			if (*expected_zero) {
+				btf_verifier_log(env, "Unsupported btf_header");
+				return -E2BIG;
+			}
+		}
 	}
 
 	hdr_copy = min_t(u32, hdr_len, sizeof(btf->hdr));
-	if (copy_from_user(&btf->hdr, btf_data, hdr_copy))
-		return -EFAULT;
+	memcpy(&btf->hdr, btf->data, hdr_copy);
 
 	hdr = &btf->hdr;
 
@@ -2186,10 +2180,6 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 	}
 	env->btf = btf;
 
-	err = btf_parse_hdr(env, btf_data, btf_data_size);
-	if (err)
-		goto errout;
-
 	data = kvmalloc(btf_data_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!data) {
 		err = -ENOMEM;
@@ -2198,13 +2188,18 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 
 	btf->data = data;
 	btf->data_size = btf_data_size;
-	btf->nohdr_data = btf->data + btf->hdr.hdr_len;
 
 	if (copy_from_user(data, btf_data, btf_data_size)) {
 		err = -EFAULT;
 		goto errout;
 	}
 
+	err = btf_parse_hdr(env);
+	if (err)
+		goto errout;
+
+	btf->nohdr_data = btf->data + btf->hdr.hdr_len;
+
 	err = btf_parse_str_sec(env);
 	if (err)
 		goto errout;
-- 
2.20.1



