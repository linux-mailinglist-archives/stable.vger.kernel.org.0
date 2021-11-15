Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2F450CBF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbhKORmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238298AbhKORkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:40:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E96632EC;
        Mon, 15 Nov 2021 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997215;
        bh=aV4N1om+H0mX+iTl7nEnTZZqsL0GK8VHw3mR0y/l8a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CafpK46lMb+9Hw6XQciExxIN3S2xYkv6o6vT+G5DH4u0wFzfBXsmciS0fbYL5cTn4
         MSi2IfLFjaCFSSvu5GQw9EyBk9GYUPEEPw8vYQrbsOxW/dGTlrHO+WJ3zBoqDbkXOZ
         0AbuL4Pt5b8o7/uaPRx+zHOE5vgX1Q27OIV9jtgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/575] bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT
Date:   Mon, 15 Nov 2021 17:56:31 +0100
Message-Id: <20211115165345.921926518@linuxfoundation.org>
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
index 345066b8e9fc8..064577ff9ff59 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1134,6 +1134,11 @@ out:
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



