Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD53445237D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353298AbhKPB0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242517AbhKOTCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B3663352;
        Mon, 15 Nov 2021 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000097;
        bh=O+JM8CvVy9l+NyxnoIwOqNHAgLVTc3eJ/qvfIqM89B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4Tx3E6VAzUsj3AgoIjGZAVT8ip/TXemjirB+ifXKnK/M4QhJvl0xkS80uzeHGRXl
         8pM8cb1O2lN/KVQ0bGBzS94bAuyejvqed3ynOUfLoofpXx5ZEZK+O0/L5cwepir0FO
         zHd4VWv3CNTydItyAs7iaVYEA6/IdVMX9nYajH0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Vereshchagin <evvers@ya.ru>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 494/849] libbpf: Fix overflow in BTF sanity checks
Date:   Mon, 15 Nov 2021 17:59:37 +0100
Message-Id: <20211115165437.000326759@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 99d28f04b59d4..3e3ecac43ea9b 100644
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



