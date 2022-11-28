Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14A563AF53
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiK1Rkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiK1RkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:40:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2B429C84;
        Mon, 28 Nov 2022 09:39:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A8E4B80E9E;
        Mon, 28 Nov 2022 17:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E7DC433D7;
        Mon, 28 Nov 2022 17:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657145;
        bh=jKM45OyExbfPU5Q6hFu9MoABJsMbDce7lX335EsUz5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP40dZm9Ke+bRSVHF+lpesOESaOxO87HD5P896kfM5xYHXsG3Rszi8rzO/uuh3zkN
         tAF6dv/2kPVWfR7+dv5FFYVFiHJYffpLeMVCaLyLkJ1Ob7NGsEkMDC59opJUjRoNuo
         TmbChVQ9iwJWgIy1nt71g84aSMzJz0RCXFUd3TK81KaGdY2HBtDgOd2MtejKgvlHkU
         fwS89hqtTfqdE5DmFPWv68S42tSlKtFXFQkgdp+3P0GlWm29y8A5iG/yLpA4FIYPC1
         HeJqS6Wl7ICGY6VsPQt7UWRO/mSVCaOPz5hStYsNIe8EBVPEr5xf4NY+y75yOS34iO
         ymFll46i6C48g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     KaiLong Wang <wangkailong@jari.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        zhangqing@loongson.cn, loongarch@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 26/39] LoongArch: Fix unsigned comparison with less than zero
Date:   Mon, 28 Nov 2022 12:36:06 -0500
Message-Id: <20221128173642.1441232-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KaiLong Wang <wangkailong@jari.cn>

[ Upstream commit b96e74bb439f096168c78ba3ba1599e0b85cfd73 ]

Eliminate the following coccicheck warning:

./arch/loongarch/kernel/unwind_prologue.c:84:5-13: WARNING: Unsigned
expression compared with zero: frame_ra < 0

Signed-off-by: KaiLong Wang <wangkailong@jari.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_prologue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index b206d9159205..4571c3c87cd4 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -43,7 +43,8 @@ static bool unwind_by_prologue(struct unwind_state *state)
 {
 	struct stack_info *info = &state->stack_info;
 	union loongarch_instruction *ip, *ip_end;
-	unsigned long frame_size = 0, frame_ra = -1;
+	long frame_ra = -1;
+	unsigned long frame_size = 0;
 	unsigned long size, offset, pc = state->pc;
 
 	if (state->sp >= info->end || state->sp < info->begin)
-- 
2.35.1

