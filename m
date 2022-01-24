Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC59499957
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455045AbiAXVej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443036AbiAXVZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:25:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D86C0A1CF3;
        Mon, 24 Jan 2022 12:18:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52AC6614CB;
        Mon, 24 Jan 2022 20:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D491C340E5;
        Mon, 24 Jan 2022 20:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055481;
        bh=sWrk5jbRVJlqAG402l2iX4Ufc9ZFk7kkEs6gF9yU8fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUFu8ZIFli7sXl5+7GB3OMCJ9obIqmgYG76BAjhNtmhKZDPqDj8rR5rvaYda2HmDK
         pBWXRiAs8ydFb6NY9bWH7JDs2IO8dgg8CmYNmn7Jq0HhjB1mrsSgbiTa0tcCIimuMH
         UM4OVlPJ7P/ehj3fAjxx9f8q7zTaX+u+QvMKC3+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/846] libbpf: Fix using invalidated memory in bpf_linker
Date:   Mon, 24 Jan 2022 19:34:25 +0100
Message-Id: <20220124184106.090671883@linuxfoundation.org>
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
index 84095a2c2ef2a..6b2f59ddb6918 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -2001,7 +2001,7 @@ add_sym:
 static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *obj)
 {
 	struct src_sec *src_symtab = &obj->secs[obj->symtab_sec_idx];
-	struct dst_sec *dst_symtab = &linker->secs[linker->symtab_sec_idx];
+	struct dst_sec *dst_symtab;
 	int i, err;
 
 	for (i = 1; i < obj->sec_cnt; i++) {
@@ -2034,6 +2034,9 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 			return -1;
 		}
 
+		/* add_dst_sec() above could have invalidated linker->secs */
+		dst_symtab = &linker->secs[linker->symtab_sec_idx];
+
 		/* shdr->sh_link points to SYMTAB */
 		dst_sec->shdr->sh_link = linker->symtab_sec_idx;
 
-- 
2.34.1



