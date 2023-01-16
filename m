Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D0166CB06
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbjAPRJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbjAPRJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5D3265A9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DEEF6108C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B4AC433D2;
        Mon, 16 Jan 2023 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887792;
        bh=WJUcanwjyblsc1ntcBylx4M4TKLiAvggkHBKzf8gpc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGTPwxnyTnKvOvu+s3DFb4ywpkMIfxrtiq+MpVfYyE1IFmczJxMkO/YnT3Z0Dz1A8
         /8DJUSFvYtE1T1Q72iBLf6k3E854AakFvk+XP13EFEabLdRwoVAs6xfyB7KWCFuNn6
         P3N9WEi6rdJuWG2h/axE0Ef7wSAW6rm3ZIIwqntw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 283/521] powerpc/perf: callchain validate kernel stack pointer bounds
Date:   Mon, 16 Jan 2023 16:49:05 +0100
Message-Id: <20230116154859.807901927@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 32c5209214bd8d4f8c4e9d9b630ef4c671f58e79 ]

The interrupt frame detection and loads from the hypothetical pt_regs
are not bounds-checked. The next-frame validation only bounds-checks
STACK_FRAME_OVERHEAD, which does not include the pt_regs. Add another
test for this.

The user could set r1 to be equal to the address matching the first
interrupt frame - STACK_INT_FRAME_SIZE, which is in the previous page
due to the kernel redzone, and induce the kernel to load the marker from
there. Possibly this could cause a crash at least. If the user could
induce the previous page to contain a valid marker, then it might be
able to direct perf to read specific memory addresses in a way that
could be transmitted back to the user in the perf data.

Fixes: 20002ded4d93 ("perf_counter: powerpc: Add callchain support")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221127124942.1665522-4-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/callchain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 0af051a1974e..26a31a3b661e 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -68,6 +68,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 		next_sp = fp[0];
 
 		if (next_sp == sp + STACK_INT_FRAME_SIZE &&
+		    validate_sp(sp, current, STACK_INT_FRAME_SIZE) &&
 		    fp[STACK_FRAME_MARKER] == STACK_FRAME_REGS_MARKER) {
 			/*
 			 * This looks like an interrupt frame for an
-- 
2.35.1



