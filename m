Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5A349A99C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383421AbiAYDYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:24:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53752 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444546AbiAXVBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C7FB60C60;
        Mon, 24 Jan 2022 21:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5008C340E5;
        Mon, 24 Jan 2022 21:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058067;
        bh=a96iE1mVlz1u2n3mjpHmP704KBiCwyNGseo3af3XAnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhE82H9lwcLpTMTdT/hg1QvYjRKHQmFB0T0N5c1LoJpqvpDg8C4XSTo0PJVeULRv7
         PzGhov2IHWLN84SX1l9FYDYSWntlal3wz62HbGjLMbjED4QFhuNLwjjnAAMx/EqHjx
         wfyQwC4anNa6h56m4zyR06+PIQjcDILjdKaMih+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Vereshchagin <evvers@ya.ru>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0171/1039] libbpf: Fix potential misaligned memory access in btf_ext__new()
Date:   Mon, 24 Jan 2022 19:32:40 +0100
Message-Id: <20220124184130.990042419@linuxfoundation.org>
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

[ Upstream commit 401891a9debaf0a684502f2aaecf53448cee9414 ]

Perform a memory copy before we do the sanity checks of btf_ext_hdr.
This prevents misaligned memory access if raw btf_ext data is not 4-byte
aligned ([0]).

While at it, also add missing const qualifier.

  [0] Closes: https://github.com/libbpf/libbpf/issues/391

Fixes: 2993e0515bb4 ("tools/bpf: add support to read .BTF.ext sections")
Reported-by: Evgeny Vereshchagin <evvers@ya.ru>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211124002325.1737739-3-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 10 +++++-----
 tools/lib/bpf/btf.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7e4c5586bd877..c2400804d6bac 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2711,15 +2711,11 @@ void btf_ext__free(struct btf_ext *btf_ext)
 	free(btf_ext);
 }
 
-struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
+struct btf_ext *btf_ext__new(const __u8 *data, __u32 size)
 {
 	struct btf_ext *btf_ext;
 	int err;
 
-	err = btf_ext_parse_hdr(data, size);
-	if (err)
-		return libbpf_err_ptr(err);
-
 	btf_ext = calloc(1, sizeof(struct btf_ext));
 	if (!btf_ext)
 		return libbpf_err_ptr(-ENOMEM);
@@ -2732,6 +2728,10 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 	}
 	memcpy(btf_ext->data, data, size);
 
+	err = btf_ext_parse_hdr(btf_ext->data, size);
+	if (err)
+		goto done;
+
 	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, line_info_len)) {
 		err = -EINVAL;
 		goto done;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index bc005ba3ceec3..17c0a46d8cd22 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -157,7 +157,7 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 				    __u32 expected_value_size,
 				    __u32 *key_type_id, __u32 *value_type_id);
 
-LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
+LIBBPF_API struct btf_ext *btf_ext__new(const __u8 *data, __u32 size);
 LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);
 LIBBPF_API const void *btf_ext__get_raw_data(const struct btf_ext *btf_ext,
 					     __u32 *size);
-- 
2.34.1



