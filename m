Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4A66C834
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjAPQhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbjAPQg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4E73251F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E874B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049E4C433F0;
        Mon, 16 Jan 2023 16:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886319;
        bh=O4ozINCRWRTc+VeJSEDA+cCcsejkMGqv1kmmQGc1M1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2y0Q3DLxk18E09/VcgG2rPC8jbh8XgUIrYXi7sV+XpmPbxynqCsOKBIBWdDohxiK
         iKilUc8Fcu210qw25eXr6C+MhJRzrH0duoOjAwS029vihQDjCSXGYwnsfpy4nfEFIa
         s3LcdOjjYT54W0G1s8kSBXFbJ8DYgeiAlBD2xF2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 356/658] powerpc/perf: callchain validate kernel stack pointer bounds
Date:   Mon, 16 Jan 2023 16:47:24 +0100
Message-Id: <20230116154925.871712987@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index c84bbd4298a0..4c9aaedd2b1b 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -64,6 +64,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 		next_sp = fp[0];
 
 		if (next_sp == sp + STACK_INT_FRAME_SIZE &&
+		    validate_sp(sp, current, STACK_INT_FRAME_SIZE) &&
 		    fp[STACK_FRAME_MARKER] == STACK_FRAME_REGS_MARKER) {
 			/*
 			 * This looks like an interrupt frame for an
-- 
2.35.1



