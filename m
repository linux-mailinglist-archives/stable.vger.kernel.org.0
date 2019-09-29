Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34EC14F4
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbfI2N72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbfI2N71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15B0C2082F;
        Sun, 29 Sep 2019 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765566;
        bh=8M0Ni5gWktIAGrSox9qoutWjX+E8Vi8utdd0udKpVEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b10GgUmYIlNOIwigirtBB6LEqcgtLs8K0+H8v7JEW/eM3j9OphAcgqMRN76xl5h9L
         8cxvFvCwgRfpJvaYnAjQM9bo3F9oWg4TlXFr6v+MHu6EBmh5Nd094x+LSH8+06goPZ
         LV/9iHCd3Mrgb2kgnIm4icRl8CvbJXZ5eC49FAg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/63] bpf: libbpf: retry loading program on EAGAIN
Date:   Sun, 29 Sep 2019 15:54:15 +0200
Message-Id: <20190929135039.190739304@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 86edaed379632e216a97e6bcef9f498b64522d50 ]

Commit c3494801cd17 ("bpf: check pending signals while
verifying programs") makes it possible for the BPF_PROG_LOAD
to fail with EAGAIN. Retry unconditionally in this case.

Fixes: c3494801cd17 ("bpf: check pending signals while verifying programs")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index dd0b68d1f4be0..482025b728399 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -75,6 +75,17 @@ static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
 	return syscall(__NR_bpf, cmd, attr, size);
 }
 
+static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
+{
+	int fd;
+
+	do {
+		fd = sys_bpf(BPF_PROG_LOAD, attr, size);
+	} while (fd < 0 && errno == EAGAIN);
+
+	return fd;
+}
+
 int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
 {
 	__u32 name_len = create_attr->name ? strlen(create_attr->name) : 0;
@@ -218,7 +229,7 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	memcpy(attr.prog_name, load_attr->name,
 	       min(name_len, BPF_OBJ_NAME_LEN - 1));
 
-	fd = sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+	fd = sys_bpf_prog_load(&attr, sizeof(attr));
 	if (fd >= 0 || !log_buf || !log_buf_sz)
 		return fd;
 
@@ -227,7 +238,7 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	attr.log_size = log_buf_sz;
 	attr.log_level = 1;
 	log_buf[0] = 0;
-	return sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+	return sys_bpf_prog_load(&attr, sizeof(attr));
 }
 
 int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
@@ -268,7 +279,7 @@ int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 	attr.kern_version = kern_version;
 	attr.prog_flags = strict_alignment ? BPF_F_STRICT_ALIGNMENT : 0;
 
-	return sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+	return sys_bpf_prog_load(&attr, sizeof(attr));
 }
 
 int bpf_map_update_elem(int fd, const void *key, const void *value,
-- 
2.20.1



