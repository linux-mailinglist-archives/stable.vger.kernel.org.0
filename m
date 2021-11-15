Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B08E450B9E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhKORZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237799AbhKORYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C19A63231;
        Mon, 15 Nov 2021 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996713;
        bh=hAzT1RQpXOs1kB5oVWahLhGh0Gajuiu3xJpu7oFj/9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cn7AwF4KvavF5/NP/nG5X2wTXXSFt3dUhiS0oyQVoc5Oqup6zZ7cbouHZ92/etRai
         zT7vL3ZPeegI44FkLbyW4Sz52RJ+mBZLb8MBgTtUQxgR9LBi7uMjogYeZm96c2yTYU
         zfyaEh5bbRahgsrMsizcVOtxs7wzbC2/utlqlWEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/355] libbpf: Fix BTF data layout checks and allow empty BTF
Date:   Mon, 15 Nov 2021 18:02:43 +0100
Message-Id: <20211115165321.478819074@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit d8123624506cd62730c9cd9c7672c698e462703d ]

Make data section layout checks stricter, disallowing overlap of types and
strings data.

Additionally, allow BTFs with no type data. There is nothing inherently wrong
with having BTF with no types (put potentially with some strings). This could
be a situation with kernel module BTFs, if module doesn't introduce any new
type information.

Also fix invalid offset alignment check for btf->hdr->type_off.

Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20201105043402.2530976-8-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d606a358480da..3380aadb74655 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -100,22 +100,18 @@ static int btf_parse_hdr(struct btf *btf)
 		return -EINVAL;
 	}
 
-	if (meta_left < hdr->type_off) {
-		pr_debug("Invalid BTF type section offset:%u\n", hdr->type_off);
+	if (meta_left < hdr->str_off + hdr->str_len) {
+		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
 		return -EINVAL;
 	}
 
-	if (meta_left < hdr->str_off) {
-		pr_debug("Invalid BTF string section offset:%u\n", hdr->str_off);
+	if (hdr->type_off + hdr->type_len > hdr->str_off) {
+		pr_debug("Invalid BTF data sections layout: type data at %u + %u, strings data at %u + %u\n",
+			 hdr->type_off, hdr->type_len, hdr->str_off, hdr->str_len);
 		return -EINVAL;
 	}
 
-	if (hdr->type_off >= hdr->str_off) {
-		pr_debug("BTF type section offset >= string section offset. No type?\n");
-		return -EINVAL;
-	}
-
-	if (hdr->type_off & 0x02) {
+	if (hdr->type_off % 4) {
 		pr_debug("BTF type section is not aligned to 4 bytes\n");
 		return -EINVAL;
 	}
-- 
2.33.0



