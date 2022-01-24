Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1FB4998FA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453870AbiAXVbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43938 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450803AbiAXVV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81042614C9;
        Mon, 24 Jan 2022 21:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699E4C340E4;
        Mon, 24 Jan 2022 21:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059286;
        bh=qugYk4pDsPqpyUGAGLi31+juSnBWrfgIxERcbKmTZ94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cB0GTfeQQzFjcG4ZjdqTbY2Vb8wtkd9SD7KhFa8OtEmdXFBLpOQaxlnT4pvoEzt3M
         RRwswxgWAMLPzEkVkYH7RXec2fXCrodDq2qm2mwj+2x7sCsE0sRDRtClC337pF1Ugi
         5KfIAQcqE/7/lQlGYv8Nz6EEOMXn5xVISE13gnuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0548/1039] libbpf: Validate that .BTF and .BTF.ext sections contain data
Date:   Mon, 24 Jan 2022 19:38:57 +0100
Message-Id: <20220124184143.698193669@linuxfoundation.org>
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

[ Upstream commit 62554d52e71797eefa3fc15b54008038837bb2d4 ]

.BTF and .BTF.ext ELF sections should have SHT_PROGBITS type and contain
data. If they are not, ELF is invalid or corrupted, so bail out.
Otherwise this can lead to data->d_buf being NULL and SIGSEGV later on.
Reported by oss-fuzz project.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211103173213.1376990-4-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c7ba5e6ed9cfe..96cee9cd8c03c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3271,8 +3271,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 		} else if (strcmp(name, MAPS_ELF_SEC) == 0) {
 			obj->efile.btf_maps_shndx = idx;
 		} else if (strcmp(name, BTF_ELF_SEC) == 0) {
+			if (sh->sh_type != SHT_PROGBITS)
+				return -LIBBPF_ERRNO__FORMAT;
 			btf_data = data;
 		} else if (strcmp(name, BTF_EXT_ELF_SEC) == 0) {
+			if (sh->sh_type != SHT_PROGBITS)
+				return -LIBBPF_ERRNO__FORMAT;
 			btf_ext_data = data;
 		} else if (sh->sh_type == SHT_SYMTAB) {
 			/* already processed during the first pass above */
-- 
2.34.1



