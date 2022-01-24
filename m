Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7B34996C1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352980AbiAXVG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49266 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443639AbiAXU5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:57:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E440611DA;
        Mon, 24 Jan 2022 20:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47923C340E5;
        Mon, 24 Jan 2022 20:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057874;
        bh=KhvIkvCRQAidrDbmtKYuotaLjKwnMHLsfkWCzUzzhO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAOpRqgZ21eYE9LPlbvZcVp8ArLkdWRZBLAB+x2CSyJFjgRmgjrJwJ6wmIRxvs9EX
         CPRLC0Ns0/K/NNANlzkfoOfKdpEB9Ompi4HaVkLHI9j2L26KNiVerji1JN0VSrKemE
         OLPyeUw/tQ6cmpybsOLp8aCDlLedc4zwU4tGLCNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0107/1039] libbpf: Fix section counting logic
Date:   Mon, 24 Jan 2022 19:31:36 +0100
Message-Id: <20220124184128.743283043@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 0d6988e16a12ebd41d3e268992211b0ceba44ed7 ]

e_shnum does include section #0 and as such is exactly the number of ELF
sections that we need to allocate memory for to use section indices as
array indices. Fix the off-by-one error.

This is purely accounting fix, previously we were overallocating one
too many array items. But no correctness errors otherwise.

Fixes: 25bbbd7a444b ("libbpf: Remove assumptions about uniqueness of .rodata/.data/.bss maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211103173213.1376990-5-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7c74342bb6680..5367bc8e52073 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3191,11 +3191,11 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 	Elf_Scn *scn;
 	Elf64_Shdr *sh;
 
-	/* ELF section indices are 1-based, so allocate +1 element to keep
-	 * indexing simple. Also include 0th invalid section into sec_cnt for
-	 * simpler and more traditional iteration logic.
+	/* ELF section indices are 0-based, but sec #0 is special "invalid"
+	 * section. e_shnum does include sec #0, so e_shnum is the necessary
+	 * size of an array to keep all the sections.
 	 */
-	obj->efile.sec_cnt = 1 + obj->efile.ehdr->e_shnum;
+	obj->efile.sec_cnt = obj->efile.ehdr->e_shnum;
 	obj->efile.secs = calloc(obj->efile.sec_cnt, sizeof(*obj->efile.secs));
 	if (!obj->efile.secs)
 		return -ENOMEM;
-- 
2.34.1



