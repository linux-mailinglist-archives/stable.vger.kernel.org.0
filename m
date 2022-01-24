Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33125499551
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392557AbiAXUv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390818AbiAXUq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AEBC0612B1;
        Mon, 24 Jan 2022 11:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21550B80FA1;
        Mon, 24 Jan 2022 19:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D69EC340E5;
        Mon, 24 Jan 2022 19:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054164;
        bh=FWtbtmARrt7YCzY3o9axlqB5+rkW6kVoS11LNDSwnWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuwgO3yRFk/VZp1rQP4IHAbDmIMh4o+4mkEKOZ5sLELe6EUM1DXnBbg3JsH6kSdCY
         CC/ekpzhTx4HCALnSKzeqqw3jHaQI8cmpe5CRRLIy5VKv8B1x6nYzRxS5YEmza8agv
         8WmvUpbT4sPQs/XubZIZA8sVXZZS5ge+TKn/032s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/563] libbpf: Validate that .BTF and .BTF.ext sections contain data
Date:   Mon, 24 Jan 2022 19:41:05 +0100
Message-Id: <20220124184034.824126628@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index b337d6f29098b..e8ad53d31044a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2870,8 +2870,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
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
 			/* already processed during the first pass above */
-- 
2.34.1



