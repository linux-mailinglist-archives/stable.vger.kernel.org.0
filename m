Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D20452622
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344016AbhKPCCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240008AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F8826326A;
        Mon, 15 Nov 2021 17:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998091;
        bh=c4iVuIXMsz/52NQr05YW5vu6s5m/8uFQcvE5ICiv6Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quZzThI4tz2dpmLzqAmSY5csCcDwSG1mWCF2M2xD0VdtC2CK1SYGj5Z437oah97+v
         +vaSEdoO5DhD6QvssDf/nTSXQiK/wb344sgcPOXgBNTr3WnG0ypee4MP2E6yS4HfjT
         iFY5iCgLEZ9QhS/4x/9iP7UAKLmTxie6Svyo+7Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/575] bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.
Date:   Mon, 15 Nov 2021 18:01:49 +0100
Message-Id: <20211115165357.060650134@linuxfoundation.org>
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
index c56739a4a4219..a15826a9a644f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1298,7 +1298,7 @@ static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
 
 static bool __reg64_bound_s32(s64 a)
 {
-	return a > S32_MIN && a < S32_MAX;
+	return a >= S32_MIN && a <= S32_MAX;
 }
 
 static bool __reg64_bound_u32(u64 a)
-- 
2.33.0



