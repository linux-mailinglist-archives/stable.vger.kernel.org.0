Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F2321FAC7
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgGNSzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730886AbgGNSzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D9A21D79;
        Tue, 14 Jul 2020 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752935;
        bh=/OB5+buJ/dYANcHnH4H5AnXekZPVzzEHTMS/vT95zmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2X1Wb1g5VmPC6CCbfBREeo2ALgk2YO8ZLUWL763Ox/qu7eGjetoTY9z3Nub/YKen
         9jTVPo/JW5gz5mStiEWXljEVDn91+C9hpx8SSXfexT+kwBaDnynjocUTv4p4UdHYfG
         OUUA6okiLTyD1dyxuzXvjt/vK+IOx47G6ZqdJhZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 055/166] bpf: Do not allow btf_ctx_access with __int128 types
Date:   Tue, 14 Jul 2020 20:43:40 +0200
Message-Id: <20200714184118.509799543@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit a9b59159d338d414acaa8e2f569d129d51c76452 ]

To ensure btf_ctx_access() is safe the verifier checks that the BTF
arg type is an int, enum, or pointer. When the function does the
BTF arg lookup it uses the calculation 'arg = off / 8'  using the
fact that registers are 8B. This requires that the first arg is
in the first reg, the second in the second, and so on. However,
for __int128 the arg will consume two registers by default LLVM
implementation. So this will cause the arg layout assumed by the
'arg = off / 8' calculation to be incorrect.

Because __int128 is uncommon this patch applies the easiest fix and
will force int types to be sizeof(u64) or smaller so that they will
fit in a single register.

v2: remove unneeded parens per Andrii's feedback

Fixes: 9e15db66136a1 ("bpf: Implement accurate raw_tp context access via BTF")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/159303723962.11287.13309537171132420717.stgit@john-Precision-5820-Tower
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/btf.h | 5 +++++
 kernel/bpf/btf.c    | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 5c1ea99b480fa..8b81fbb4497cf 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -82,6 +82,11 @@ static inline bool btf_type_is_int(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
 }
 
+static inline bool btf_type_is_small_int(const struct btf_type *t)
+{
+	return btf_type_is_int(t) && t->size <= sizeof(u64);
+}
+
 static inline bool btf_type_is_enum(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index d65c6912bdaf6..d1f5d428c9fe2 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3744,7 +3744,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 				return false;
 
 			t = btf_type_skip_modifiers(btf, t->type, NULL);
-			if (!btf_type_is_int(t)) {
+			if (!btf_type_is_small_int(t)) {
 				bpf_log(log,
 					"ret type %s not allowed for fmod_ret\n",
 					btf_kind_str[BTF_INFO_KIND(t->info)]);
@@ -3766,7 +3766,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
 		t = btf_type_by_id(btf, t->type);
-	if (btf_type_is_int(t) || btf_type_is_enum(t))
+	if (btf_type_is_small_int(t) || btf_type_is_enum(t))
 		/* accessing a scalar */
 		return true;
 	if (!btf_type_is_ptr(t)) {
-- 
2.25.1



