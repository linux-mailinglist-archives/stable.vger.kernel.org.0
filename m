Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72745264B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345988AbhKPCEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhKOSFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D4C763369;
        Mon, 15 Nov 2021 17:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998003;
        bh=OBWsx9oxRROBWrSmCUdV3UoxH9QoDRjrye3pw1Yq/Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnbaZEomMq5menOH7OXFvBeClO4SyRBqdBmnGtcJGpcDkoFJX34D07ICqqAOXbfBj
         PEznzPIJRS1wkqcJr2nfhf8h1FtQIiqOeyBbTUIxcpn7Wd7XenLQMOazwKn+nWQE7R
         1Vv7mKjc8v7aocYP9lAnWPN/2vUG0cdym37yCOsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christopher William Snowhill <chris@kode54.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/575] libbpf: Allow loading empty BTFs
Date:   Mon, 15 Nov 2021 18:01:16 +0100
Message-Id: <20211115165355.934693074@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit b8d52264df85ec12f370c0a8b28d0ac59a05877a ]

Empty BTFs do come up (e.g., simple kernel modules with no new types and
strings, compared to the vmlinux BTF) and there is nothing technically wrong
with them. So remove unnecessary check preventing loading empty BTFs.

Fixes: d8123624506c ("libbpf: Fix BTF data layout checks and allow empty BTF")
Reported-by: Christopher William Snowhill <chris@kode54.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210110070341.1380086-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 987c1515b828b..c8c751265e23a 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -210,11 +210,6 @@ static int btf_parse_hdr(struct btf *btf)
 	}
 
 	meta_left = btf->raw_size - sizeof(*hdr);
-	if (!meta_left) {
-		pr_debug("BTF has no data\n");
-		return -EINVAL;
-	}
-
 	if (meta_left < hdr->str_off + hdr->str_len) {
 		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
 		return -EINVAL;
-- 
2.33.0



