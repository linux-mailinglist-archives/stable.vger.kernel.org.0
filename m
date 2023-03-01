Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9816A7306
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCASLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjCASLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:11:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A514BE9D
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:11:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 913DFB810C3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA9EC433EF;
        Wed,  1 Mar 2023 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694306;
        bh=v+bxS92eEW7pI9O3JFHezo1OLSIygAVyXQ21fOBt/co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBbz7HovfgiGjNsm8YTh0EFKVd7Ec2Z2KcJFoiDN5xUyxCrZXhGmDFkrJCRvJezvZ
         r624i1EHouD2HGx8KxwBvTu1JZhAiUhJ22bhxT/wYqzIoADTEfPf+Lkt8c+J2VIMj3
         6u8QOUONKq4kWKoYQyhid/QEGzaINycXv/SA3asE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sachin Sant <sachinp@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/42] powerpc: Dont select ARCH_WANTS_NO_INSTR
Date:   Wed,  1 Mar 2023 19:08:36 +0100
Message-Id: <20230301180657.737651600@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
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



