Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029F84513E6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348698AbhKOT7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344101AbhKOTXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E196563624;
        Mon, 15 Nov 2021 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002317;
        bh=jqQBdfUsTlqpcw03DTdGrapHz4I8+P3ZjmDSc5kaC+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnNQQmoEB4J9BqMvst2FFY0cd+0/xujeBXc/mIdEEZnwoqt2dVlGQZMy0W47WKSkA
         XgTYXJgbsGfqUg7XIsFNxp+ylsXU0E0zWvf/QnFzzNgpmu9zYCGq0XkNdedty0KO5N
         Bd5BrpcMf+xlJhERdzI9ZkVZZFQVsOoYKtk1q+Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 519/917] libbpf: Fix off-by-one bug in bpf_core_apply_relo()
Date:   Mon, 15 Nov 2021 18:00:14 +0100
Message-Id: <20211115165446.370596220@linuxfoundation.org>
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

[ Upstream commit de5d0dcef602de39070c31c7e56c58249c56ba37 ]

Fix instruction index validity check which has off-by-one error.

Fixes: 3ee4f5335511 ("libbpf: Split bpf_core_apply_relo() into bpf_program independent helper.")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211025224531.1088894-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 51180f300d2e1..7145463a4a562 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5138,7 +5138,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	 * relocated, so it's enough to just subtract in-section offset
 	 */
 	insn_idx = insn_idx - prog->sec_insn_off;
-	if (insn_idx > prog->insns_cnt)
+	if (insn_idx >= prog->insns_cnt)
 		return -EINVAL;
 	insn = &prog->insns[insn_idx];
 
-- 
2.33.0



