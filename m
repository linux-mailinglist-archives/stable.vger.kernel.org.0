Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082B9499910
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454059AbiAXVbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451331AbiAXVWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:22:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5222EB8123A;
        Mon, 24 Jan 2022 21:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76659C340E5;
        Mon, 24 Jan 2022 21:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059359;
        bh=9n98TaX+hUU8kjXcOlvMGtKM6jKo4501BytYLKGahLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhxDa85WKc3dpC+Iisml4rNXfOmm/n5kQtjixhHbQOLbODMl+0NPiJon4/IAdx/bh
         lGyYDy7iJ2R/iyPpvrwyN/PBoMDHfo8Ij8XScW/TUObtMdlfTPcLU7HAo+PqOASLta
         sRnanMXNquQIEk6c1FNHcbdPHkv5bV82XaQ1LP5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0546/1039] libbpf: Detect corrupted ELF symbols section
Date:   Mon, 24 Jan 2022 19:38:55 +0100
Message-Id: <20220124184143.626129823@linuxfoundation.org>
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

[ Upstream commit 833907876be55205d0ec153dcd819c014404ee16 ]

Prevent divide-by-zero if ELF is corrupted and has zero sh_entsize.
Reported by oss-fuzz project.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211103173213.1376990-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2696f0b7f0acc..1cc0383471f01 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3556,7 +3556,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 
 	scn = elf_sec_by_idx(obj, obj->efile.symbols_shndx);
 	sh = elf_sec_hdr(obj, scn);
-	if (!sh)
+	if (!sh || sh->sh_entsize != sizeof(Elf64_Sym))
 		return -LIBBPF_ERRNO__FORMAT;
 
 	dummy_var_btf_id = add_dummy_ksym_var(obj->btf);
-- 
2.34.1



