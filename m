Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079A8498DA5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345524AbiAXTeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:34:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347666AbiAXTcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:32:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F548B81232;
        Mon, 24 Jan 2022 19:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A331C36AFB;
        Mon, 24 Jan 2022 19:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052725;
        bh=heTk60CDtiDxyRuaYkCe/Cwdp8eX4YXc3TH7vtDBWIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHmEnV6HMrtzpH9dNQnPPc+OjTZ4ZusFmOZYWiwSn/SXa2Ou5zXMqkYHpLuQ47fVx
         hXXjCTap/0CKFzZnRkZnM5JGXfnvFzI4ogBjpzyaoHWejhppjkOkAWfoaYZzZgyjwy
         mYVW5eG+ILXRbVSrfQDp0GNJF1OiOKuyZM6Klg00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/320] libbpf: Validate that .BTF and .BTF.ext sections contain data
Date:   Mon, 24 Jan 2022 19:42:18 +0100
Message-Id: <20220124183958.868121722@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 2a1dbf52fc9a5..54e776886bf1e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1578,8 +1578,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
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
 		} else if (sh.sh_type == SHT_SYMTAB) {
 			if (obj->efile.symbols) {
-- 
2.34.1



