Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331F5451F4F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355943AbhKPAiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344053AbhKOTXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3653633BD;
        Mon, 15 Nov 2021 18:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002272;
        bh=n1CJL2aqkgCPbO6GD5Dze7UTSEKi0xcM60f56OOSx/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKvdCl7aJrNY0EHNf3qj8LQ28EVygyrARDnKKe8fIoHUhS49hKIQVAs4yL33sI9FZ
         /deamdN6v+bIkKZDM+RpygjKyNHjnQ4vy7ZNcW7P2TESgRMgafazN753UAWSfd48sT
         0tJaEFwqJGRVD/sR5SpJCKngaxc70ThEhs1QaeMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Vereshchagin <evvers@ya.ru>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 503/917] libbpf: Fix overflow in BTF sanity checks
Date:   Mon, 15 Nov 2021 17:59:58 +0100
Message-Id: <20211115165445.821188228@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 5245dafe3d49efba4d3285cf27ee1cc1eeafafc6 ]

btf_header's str_off+str_len or type_off+type_len can overflow as they
are u32s. This will lead to bypassing the sanity checks during BTF
parsing, resulting in crashes afterwards. Fix by using 64-bit signed
integers for comparison.

Fixes: d8123624506c ("libbpf: Fix BTF data layout checks and allow empty BTF")
Reported-by: Evgeny Vereshchagin <evvers@ya.ru>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211023003157.726961-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index bf8c8676d68e5..cfd701debcf61 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -236,12 +236,12 @@ static int btf_parse_hdr(struct btf *btf)
 	}
 
 	meta_left = btf->raw_size - sizeof(*hdr);
-	if (meta_left < hdr->str_off + hdr->str_len) {
+	if (meta_left < (long long)hdr->str_off + hdr->str_len) {
 		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
 		return -EINVAL;
 	}
 
-	if (hdr->type_off + hdr->type_len > hdr->str_off) {
+	if ((long long)hdr->type_off + hdr->type_len > hdr->str_off) {
 		pr_debug("Invalid BTF data sections layout: type data at %u + %u, strings data at %u + %u\n",
 			 hdr->type_off, hdr->type_len, hdr->str_off, hdr->str_len);
 		return -EINVAL;
-- 
2.33.0



