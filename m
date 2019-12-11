Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E367911B04E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfLKPVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729663AbfLKPV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBEEF24658;
        Wed, 11 Dec 2019 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077689;
        bh=QqZtaoiTzgvFT0/xdxSmNilbB4vI6VA3v6uX4v+6WZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDNZRZLtxAwBTvWV2PoRcz+gUgd24omRX81NBHOvaD5aGVvtzMatQR1PR5m7N8uEL
         rgG+nYeGrm+WkEzNEH6mVCHCzs5DaaBNvB+KmGbguFU3gpwgwFTQ9iZW4EoVvXuHQp
         S9nycrRx6bTuALzvS8Xs+LeQYpmAXLRZvhEhH6uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/243] bpf: btf: implement btf_name_valid_identifier()
Date:   Wed, 11 Dec 2019 16:04:55 +0100
Message-Id: <20191211150348.108202779@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit cdbb096adddb3f42584cecb5ec2e07c26815b71f ]

Function btf_name_valid_identifier() have been implemented in
bpf-next commit 2667a2626f4d ("bpf: btf: Add BTF_KIND_FUNC and
BTF_KIND_FUNC_PROTO"). Backport this function so later patch
can use it.

Fixes: 69b693f0aefa ("bpf: btf: Introduce BPF Type Format (BTF)")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cfa27b7d1168c..f0f9109f59bac 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5,6 +5,7 @@
 #include <uapi/linux/types.h>
 #include <linux/seq_file.h>
 #include <linux/compiler.h>
+#include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/anon_inodes.h>
@@ -426,6 +427,30 @@ static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
 		offset < btf->hdr.str_len;
 }
 
+/* Only C-style identifier is permitted. This can be relaxed if
+ * necessary.
+ */
+static bool btf_name_valid_identifier(const struct btf *btf, u32 offset)
+{
+	/* offset must be valid */
+	const char *src = &btf->strings[offset];
+	const char *src_limit;
+
+	if (!isalpha(*src) && *src != '_')
+		return false;
+
+	/* set a limit on identifier length */
+	src_limit = src + KSYM_NAME_LEN;
+	src++;
+	while (*src && src < src_limit) {
+		if (!isalnum(*src) && *src != '_')
+			return false;
+		src++;
+	}
+
+	return !*src;
+}
+
 static const char *btf_name_by_offset(const struct btf *btf, u32 offset)
 {
 	if (!offset)
-- 
2.20.1



