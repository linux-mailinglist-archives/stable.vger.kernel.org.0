Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7A958BEBA
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241886AbiHHBbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241889AbiHHBbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:31:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB814B851;
        Sun,  7 Aug 2022 18:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F01EB80DC0;
        Mon,  8 Aug 2022 01:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED3AC433D6;
        Mon,  8 Aug 2022 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922297;
        bh=v+8BW4sU+DYYuLIMxucs4tnKqWv7E/wqEuADuGahClE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBuII1XvyD43H3GdTzmpcNaPi1tI0Oz0oqtTEg+Qq4/XlC+pHuoFxWEVv/sPSrSoA
         GuW1eQHDKUKoSTABX8xl8wNE0XHr8oMZ/vQlwHFSQ8yJOQPI0Uno/tIbsUReilho7W
         zX/gm9k/Um1MxrMMZSjJoliV1+M0dTXwCTUYmXOxBj4QTUkad/NC2exj8GwLytaFWu
         W+v5TD/Jhz2f4ULBgD74Pqu0gWgJTDod2j7V+pLGDWidWXUBTTSZL3RW9Af42St4wn
         fHquOUu8u+0rnasxBNEZgOxCZzlOkBBtC2z2XJ1sKcDuRKZeMUn+t1jOdPZMmtwnVM
         cxULgFbee+PjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, broonie@kernel.org,
        kaleshsingh@google.com, madvenka@linux.microsoft.com,
        mhiramat@kernel.org, andreyknvl@gmail.com, maz@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 04/58] arm64: stacktrace: use non-atomic __set_bit
Date:   Sun,  7 Aug 2022 21:30:22 -0400
Message-Id: <20220808013118.313965-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

[ Upstream commit 446297b28a21244e4045026c4599d1b14a67e2ce ]

Use the non-atomic version of set_bit() in arch/arm64/kernel/stacktrace.c,
as there is no concurrent accesses to frame->prev_type.

This speeds up stack trace collection and improves the boot time of
Generic KASAN by 2-5%.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lore.kernel.org/r/23dfa36d1cc91e4a1059945b7834eac22fb9854d.1653317461.git.andreyknvl@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index c246e8d9f95b..d6bef106e37e 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -117,7 +117,7 @@ static int notrace unwind_next(struct task_struct *tsk,
 		if (fp <= state->prev_fp)
 			return -EINVAL;
 	} else {
-		set_bit(state->prev_type, state->stacks_done);
+		__set_bit(state->prev_type, state->stacks_done);
 	}
 
 	/*
-- 
2.35.1

