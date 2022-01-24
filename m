Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F634999EA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378065AbiAXViq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453244AbiAXV3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:29:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBEAC01D7F8;
        Mon, 24 Jan 2022 12:19:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E225614F1;
        Mon, 24 Jan 2022 20:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A999C340E7;
        Mon, 24 Jan 2022 20:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055552;
        bh=yiA0GstymHS+bc02p/Gx+tEEuIuC200OPfmxzKSnoKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIA43s7yaKZNlxddHDubcpCVyfXH9wHXy/xsvto6pDGjGjULFnWXoVtW8dVwvpc8/
         HSKxfjSNYVVL23SDoDoUnq0DhVUdSMvvcBg4ZRN7yR0lhlDcileBvDdUxgbVaYRFar
         gmvMGLxUR7ydQu+zvHVyAfZLkqzpbMjAggKja6z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Vereshchagin <evvers@ya.ru>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/846] libbpf: Fix potential misaligned memory access in btf_ext__new()
Date:   Mon, 24 Jan 2022 19:34:23 +0100
Message-Id: <20220124184106.027260153@linuxfoundation.org>
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
index 1b9341ef638b0..5fa64a7f0dda8 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2626,15 +2626,11 @@ void btf_ext__free(struct btf_ext *btf_ext)
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
@@ -2647,6 +2643,10 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
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
index 4a711f990904b..b0ee338a0cc87 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -80,7 +80,7 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 				    __u32 expected_value_size,
 				    __u32 *key_type_id, __u32 *value_type_id);
 
-LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
+LIBBPF_API struct btf_ext *btf_ext__new(const __u8 *data, __u32 size);
 LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);
 LIBBPF_API const void *btf_ext__get_raw_data(const struct btf_ext *btf_ext,
 					     __u32 *size);
-- 
2.34.1



