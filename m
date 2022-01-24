Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE01E4996ED
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376581AbiAXVH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53848 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444634AbiAXVBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5DC061368;
        Mon, 24 Jan 2022 21:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E10C340E5;
        Mon, 24 Jan 2022 21:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058073;
        bh=WYGVexxiQzWsmwuFARY5sLnWD4LDm3nwZavgR065GQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybugiiHT5Hbw073FMy7P+nlWmCucYzdSzD/sxbU+BPEbVl1y2feW2J6eOc4ZsIHJ5
         vJKHw6mgXS37G46UW6K1D3tbKLmlD5nxNgTyW3R/E0aetga0HKdJ1A1B2XF04hv5dT
         yD+8toHP6A/+wQMu2HgwWqsDTTlay3TpRV2AzOho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0173/1039] libbpf: Fix using invalidated memory in bpf_linker
Date:   Mon, 24 Jan 2022 19:32:42 +0100
Message-Id: <20220124184131.070872399@linuxfoundation.org>
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

[ Upstream commit 593835377f24ca1bb98008ec1dc3baefe491ad6e ]

add_dst_sec() can invalidate bpf_linker's section index making
dst_symtab pointer pointing into unallocated memory. Reinitialize
dst_symtab pointer on each iteration to make sure it's always valid.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211124002325.1737739-7-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 94bdd97859285..6923a0ab3b127 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -2000,7 +2000,7 @@ add_sym:
 static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *obj)
 {
 	struct src_sec *src_symtab = &obj->secs[obj->symtab_sec_idx];
-	struct dst_sec *dst_symtab = &linker->secs[linker->symtab_sec_idx];
+	struct dst_sec *dst_symtab;
 	int i, err;
 
 	for (i = 1; i < obj->sec_cnt; i++) {
@@ -2033,6 +2033,9 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 			return -1;
 		}
 
+		/* add_dst_sec() above could have invalidated linker->secs */
+		dst_symtab = &linker->secs[linker->symtab_sec_idx];
+
 		/* shdr->sh_link points to SYMTAB */
 		dst_sec->shdr->sh_link = linker->symtab_sec_idx;
 
-- 
2.34.1



