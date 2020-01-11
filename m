Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10872138007
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgAKKZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730627AbgAKKZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:17 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43D822082E;
        Sat, 11 Jan 2020 10:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738316;
        bh=y5ZUJdBGvEd9wU+ozgECUMyVdZfnmtAjppTvIhvO/fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szwNqUxyKcfeX/v9VpefpvgFTlmCcHpjgoj/zMMyu3BREsbF67R1uS4lqcNx0AHwL
         FUpLGPdupd7K1i5nbaTF5jjbjKmkpa/7Dji4H8dgi/AnLVFMnjexwR1eqWhZzV4sCT
         rGGOW76OLT5xkDKDgxVLG0eDMbEmjUiJ0J3pyn3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/165] bpftool: Dont crash on missing jited insns or ksyms
Date:   Sat, 11 Jan 2020 10:49:34 +0100
Message-Id: <20200111094925.886400657@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 5b79bcdf03628a3a9ee04d9cd5fabcf61a8e20be ]

When the kptr_restrict sysctl is set, the kernel can fail to return
jited_ksyms or jited_prog_insns, but still have positive values in
nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when
trying to dump the program because it only checks the len fields not
the actual pointers to the instructions and ksyms.

Fix this by adding the missing checks.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Fixes: f84192ee00b7 ("tools: bpftool: resolve calls without using imm field")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20191210181412.151226-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c          | 2 +-
 tools/bpf/bpftool/xlated_dumper.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 43fdbbfe41bb..ea0bcd58bcb9 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -493,7 +493,7 @@ static int do_dump(int argc, char **argv)
 
 	info = &info_linear->info;
 	if (mode == DUMP_JITED) {
-		if (info->jited_prog_len == 0) {
+		if (info->jited_prog_len == 0 || !info->jited_prog_insns) {
 			p_info("no instructions returned");
 			goto err_free;
 		}
diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
index 494d7ae3614d..5b91ee65a080 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -174,7 +174,7 @@ static const char *print_call(void *private_data,
 	struct kernel_sym *sym;
 
 	if (insn->src_reg == BPF_PSEUDO_CALL &&
-	    (__u32) insn->imm < dd->nr_jited_ksyms)
+	    (__u32) insn->imm < dd->nr_jited_ksyms && dd->jited_ksyms)
 		address = dd->jited_ksyms[insn->imm];
 
 	sym = kernel_syms_search(dd, address);
-- 
2.20.1



