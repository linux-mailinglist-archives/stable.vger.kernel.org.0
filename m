Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2A449A944
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322390AbiAYDVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46800 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356723AbiAXUUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:20:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF0CF61496;
        Mon, 24 Jan 2022 20:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF72C340E5;
        Mon, 24 Jan 2022 20:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055644;
        bh=b7tX3ZlHFJtdTxVMz/rlSEv/QGf1NcHRNgd6ZSQZdFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2o4DZ2A+OjpQ/GQJp3oOCLTyaATTc/mtZgHuXMO1A/jblHz/AnHmBcAuzrU20n7Wd
         APeI2KROYkD9Z0mXm9ggGpLJYPQmx3wheQh84l7764X6iL7zGjMRwjfqg3QUropOcM
         kIZwtv+vRo/vKR9uj/uirrw3R9ri5jPb9nHG0TW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/846] libbpf: Clean gen_loaders attach kind.
Date:   Mon, 24 Jan 2022 19:35:02 +0100
Message-Id: <20220124184107.359387999@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 19250f5fc0c283892a61f3abf9d65e6325f63897 ]

The gen_loader has to clear attach_kind otherwise the programs
without attach_btf_id will fail load if they follow programs
with attach_btf_id.

Fixes: 67234743736a ("libbpf: Generate loader program out of BPF ELF file.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211201181040.23337-12-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 8df718a6b142d..33c19590ee434 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -663,9 +663,11 @@ void bpf_gen__prog_load(struct bpf_gen *gen,
 	debug_ret(gen, "prog_load %s insn_cnt %d", attr.prog_name, attr.insn_cnt);
 	/* successful or not, close btf module FDs used in extern ksyms and attach_btf_obj_fd */
 	cleanup_relos(gen, insns);
-	if (gen->attach_kind)
+	if (gen->attach_kind) {
 		emit_sys_close_blob(gen,
 				    attr_field(prog_load_attr, attach_btf_obj_fd));
+		gen->attach_kind = 0;
+	}
 	emit_check_err(gen);
 	/* remember prog_fd in the stack, if successful */
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7,
-- 
2.34.1



