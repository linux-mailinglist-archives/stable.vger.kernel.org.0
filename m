Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF004993AA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386079AbiAXUfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51138 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384314AbiAXU33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:29:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32CEF61502;
        Mon, 24 Jan 2022 20:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A89CC340E5;
        Mon, 24 Jan 2022 20:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056167;
        bh=th4VKO5Ug+nK9IqtFEODJ6OwStYjXRjMQK8H8lx4WDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/uYKVDakIY6izgRp23TaOjmuR7h4nwOSvpOc89iLfAN2heZladNdckLFvbCngVp+
         SBiH1lsoNBCfhz7sP0mZvclxGJSwpoYufebGEu0drNe3JNSNWMdjQO6PUVAg6uweF5
         7xZ9IkJvEicPuHp0p83cjnbqn2ItuS/JfDypTyw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/846] powerpc/32s: Fix shift-out-of-bounds in KASAN init
Date:   Mon, 24 Jan 2022 19:38:29 +0100
Message-Id: <20220124184114.464732347@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit af11dee4361b3519981fa04d014873f9d9edd6ac ]

================================================================================
UBSAN: shift-out-of-bounds in arch/powerpc/mm/kasan/book3s_32.c:22:23
shift exponent -1 is negative
CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.5-gentoo-PowerMacG4 #9
Call Trace:
[c214be60] [c0ba0048] dump_stack_lvl+0x80/0xb0 (unreliable)
[c214be80] [c0b99288] ubsan_epilogue+0x10/0x5c
[c214be90] [c0b98fe0] __ubsan_handle_shift_out_of_bounds+0x94/0x138
[c214bf00] [c1c0f010] kasan_init_region+0xd8/0x26c
[c214bf30] [c1c0ed84] kasan_init+0xc0/0x198
[c214bf70] [c1c08024] setup_arch+0x18/0x54c
[c214bfc0] [c1c037f0] start_kernel+0x90/0x33c
[c214bff0] [00003610] 0x3610
================================================================================

This happens when the directly mapped memory is a power of 2.

Fix it by checking the shift and set the result to 0 when shift is -1

Fixes: 7974c4732642 ("powerpc/32s: Implement dedicated kasan_init_region()")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215169
Link: https://lore.kernel.org/r/15cbc3439d4ad988b225e2119ec99502a5cc6ad3.1638261744.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/kasan/book3s_32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/kasan/book3s_32.c b/arch/powerpc/mm/kasan/book3s_32.c
index 202bd260a0095..35b287b0a8da4 100644
--- a/arch/powerpc/mm/kasan/book3s_32.c
+++ b/arch/powerpc/mm/kasan/book3s_32.c
@@ -19,7 +19,8 @@ int __init kasan_init_region(void *start, size_t size)
 	block = memblock_alloc(k_size, k_size_base);
 
 	if (block && k_size_base >= SZ_128K && k_start == ALIGN(k_start, k_size_base)) {
-		int k_size_more = 1 << (ffs(k_size - k_size_base) - 1);
+		int shift = ffs(k_size - k_size_base);
+		int k_size_more = shift ? 1 << (shift - 1) : 0;
 
 		setbat(-1, k_start, __pa(block), k_size_base, PAGE_KERNEL);
 		if (k_size_more >= SZ_128K)
-- 
2.34.1



