Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86B6451447
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349001AbhKOUBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344295AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43FC0633C8;
        Mon, 15 Nov 2021 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002512;
        bh=BWRiKMcHMaxjt883Xsxh/3Lxa54SCFJR/j1OFlVN0jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ7cYCxY5NNwZm3XRz7RQGc1AjEYEIQ3AhOaD6VtRGX8luFvPQjjBDU1cHRYD8tkZ
         sU3kUsblFlUcJYwCFt8MEjUN8NwYrC4tMdQ7k3gnfFp4wO4GhgGdunJort2AA7ECvg
         Ejw6KX/okD1f79S0ZwMMx5GpnxpYWzYdr0y6WPHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/917] bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.
Date:   Mon, 15 Nov 2021 18:00:58 +0100
Message-Id: <20211115165447.885313920@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 388e2c0b978339dee9b0a81a2e546f8979e021e2 ]

Similar to unsigned bounds propagation fix signed bounds.
The 'Fixes' tag is a hint. There is no security bug here.
The verifier was too conservative.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211101222153.78759-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 055012faca94e..ddba80554fef3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1406,7 +1406,7 @@ static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
 
 static bool __reg64_bound_s32(s64 a)
 {
-	return a > S32_MIN && a < S32_MAX;
+	return a >= S32_MIN && a <= S32_MAX;
 }
 
 static bool __reg64_bound_u32(u64 a)
-- 
2.33.0



