Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738C56985FD
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjBOUrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjBOUqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:46:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356CD43467;
        Wed, 15 Feb 2023 12:46:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7724EB823AF;
        Wed, 15 Feb 2023 20:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5198C433EF;
        Wed, 15 Feb 2023 20:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493975;
        bh=v+bxS92eEW7pI9O3JFHezo1OLSIygAVyXQ21fOBt/co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lb5Z5gww1GskdX4NQOGug1FDtMXnro9dXYI0K8dFY4M9FlKAtENTJ1He4VthlegMD
         7CTBeWkiUGY5+IRWV+1FD0BYZQhBxmhgk7vqx3lXF8+tZJLAKHINrfS81TY3HefTub
         GRTPSWMZa3+qgs7P47+bK5antnJFQy7QwRvfqllukioCjYLYuyt7XCBtZdoGP8PsAI
         FHFdKMNahA8I5vL/ZojF6Ni8DGdDX866dMYu1QFUM0rA9fK2ZhSxEFRJNVtw+J0eWr
         OMSODRqQA1vZaI+yTrMg9ZZGhbgoJJj2E5WYbMhMr2pgp1VWPZ2A3uwqrVPvjfcjc0
         7JuMBxb9WLhkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 15/24] powerpc: Don't select ARCH_WANTS_NO_INSTR
Date:   Wed, 15 Feb 2023 15:45:38 -0500
Message-Id: <20230215204547.2760761-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit e33416fca8a2313b8650bd5807aaf34354d39a4c ]

Commit 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
support") added a select of ARCH_WANTS_NO_INSTR, because it also added
some uses of noinstr. However noinstr is always defined, regardless of
ARCH_WANTS_NO_INSTR, so there's no need to select it just for that.

As PeterZ says [1]:
  Note that by selecting ARCH_WANTS_NO_INSTR you effectively state to
  abide by its rules.

As of now the powerpc code does not abide by those rules, and trips some
new warnings added by Peter in linux-next.

So until the code can be fixed to avoid those warnings, disable
ARCH_WANTS_NO_INSTR.

Note that ARCH_WANTS_NO_INSTR is also used to gate building KCOV and
parts of KCSAN. However none of the noinstr annotations in powerpc were
added for KCOV or KCSAN, instead instrumentation is blocked at the file
level using KCOV_INSTRUMENT_foo.o := n.

[1]: https://lore.kernel.org/linuxppc-dev/Y9t6yoafrO5YqVgM@hirez.programming.kicks-ass.net

Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2ca5418457ed2..2b1141645d9e1 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -161,7 +161,6 @@ config PPC
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_MODULES_DATA_IN_VMALLOC	if PPC_BOOK3S_32 || PPC_8xx
-	select ARCH_WANTS_NO_INSTR
 	select ARCH_WEAK_RELEASE_ACQUIRE
 	select BINFMT_ELF
 	select BUILDTIME_TABLE_SORT
-- 
2.39.0

