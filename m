Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D064A13D
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiLLNhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbiLLNgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89591400B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:36:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5692961072
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139F8C433EF;
        Mon, 12 Dec 2022 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852184;
        bh=jKM45OyExbfPU5Q6hFu9MoABJsMbDce7lX335EsUz5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPHu6rBdUP9j3IzXBj7oe8vWDvto35JUIcejgshNtFoKrQZ78LLNdcpGVou6z8/v9
         K3yDkA0L2MAE4HtwjgZLYtxetz1AKePwQukd3YYXSsopPpYyt2vMR2XV4xhd5vBx/K
         hAETfa/lYM3hWfa8gZQCjnohq+UIYWtmTF0Mf5DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, KaiLong Wang <wangkailong@jari.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 028/157] LoongArch: Fix unsigned comparison with less than zero
Date:   Mon, 12 Dec 2022 14:16:16 +0100
Message-Id: <20221212130935.649804395@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



