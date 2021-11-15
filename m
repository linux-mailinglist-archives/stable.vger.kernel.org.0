Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52155450ABF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhKOROX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236783AbhKORMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA1BC61BD2;
        Mon, 15 Nov 2021 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996186;
        bh=nT29tOonLZyIVBUT79fB2ueAINJ036I800GYLiZPX/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VokZoH0RhDQgRPrvPjpXLao7kTyZY0WvZ7HxjIME1VFT6kbJRDyXmYLlzoERzgCtp
         47YUTNBfqMYObMr1kOJZFK6T4zPndSjwkN2SkWySzL1P/J6IqLKaAddtNiWqUoTZ2J
         BuZW8C2W/wB9CHVCNNukk4hpafn8IE2CsZWkbAyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/355] bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT
Date:   Mon, 15 Nov 2021 17:59:31 +0100
Message-Id: <20211115165315.072260694@linuxfoundation.org>
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

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 5d63ae908242f028bd10860cba98450d11c079b8 ]

Expose the maximum amount of useable memory from the arm64 JIT.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211014142554.53120-3-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index afc7d41347f73..a343677837c77 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -996,6 +996,11 @@ out:
 	return prog;
 }
 
+u64 bpf_jit_alloc_exec_limit(void)
+{
+	return BPF_JIT_REGION_SIZE;
+}
+
 void *bpf_jit_alloc_exec(unsigned long size)
 {
 	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-- 
2.33.0



