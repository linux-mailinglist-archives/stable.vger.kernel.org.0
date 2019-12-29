Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D710B12C6EF
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732212AbfL2RwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732210AbfL2RwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D9FC207FF;
        Sun, 29 Dec 2019 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641925;
        bh=xCXYEYO7WU5ptonoCTDEHOUN/umnP26BvYCg3fb/y1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1DSRyDkvyvVvMrqAXq9d79HXKMxcFWdy3fxT57IVHacvWu/99NkmunvQmb7LKGB/
         MFYt1KLbPIthm0wz+5YWFrtf3/zOEFSLo0h9MhG0pc31BE3xhc94wwl+ZfIxMa+0DG
         taVLFtbiCFDIfYMfvYclL9Z3thueKkikirLCu6Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 268/434] s390/bpf: Use kvcalloc for addrs array
Date:   Sun, 29 Dec 2019 18:25:21 +0100
Message-Id: <20191229172719.740343130@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 166f11d11f6f70439830d09bfa5552ec1b368494 ]

A BPF program may consist of 1m instructions, which means JIT
instruction-address mapping can be as large as 4m. s390 has
FORCE_MAX_ZONEORDER=9 (for memory hotplug reasons), which means maximum
kmalloc size is 1m. This makes it impossible to JIT programs with more
than 256k instructions.

Fix by using kvcalloc, which falls back to vmalloc for larger
allocations. An alternative would be to use a radix tree, but that is
not supported by bpf_prog_fill_jited_linfo.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107141838.92202-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index ce88211b9c6c..c8c16b5eed6b 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -23,6 +23,7 @@
 #include <linux/filter.h>
 #include <linux/init.h>
 #include <linux/bpf.h>
+#include <linux/mm.h>
 #include <asm/cacheflush.h>
 #include <asm/dis.h>
 #include <asm/facility.h>
@@ -1369,7 +1370,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	}
 
 	memset(&jit, 0, sizeof(jit));
-	jit.addrs = kcalloc(fp->len + 1, sizeof(*jit.addrs), GFP_KERNEL);
+	jit.addrs = kvcalloc(fp->len + 1, sizeof(*jit.addrs), GFP_KERNEL);
 	if (jit.addrs == NULL) {
 		fp = orig_fp;
 		goto out;
@@ -1422,7 +1423,7 @@ skip_init_ctx:
 	if (!fp->is_func || extra_pass) {
 		bpf_prog_fill_jited_linfo(fp, jit.addrs + 1);
 free_addrs:
-		kfree(jit.addrs);
+		kvfree(jit.addrs);
 		kfree(jit_data);
 		fp->aux->jit_data = NULL;
 	}
-- 
2.20.1



