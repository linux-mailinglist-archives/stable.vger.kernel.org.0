Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07729540982
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbiFGSJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349651AbiFGSHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:07:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E2B2CDE2;
        Tue,  7 Jun 2022 10:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D13586172E;
        Tue,  7 Jun 2022 17:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFBBC385A5;
        Tue,  7 Jun 2022 17:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624079;
        bh=mPjFnB12v9QIjvkloTIVfkJB+ZjteATQWCqedBdGsPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pewzsDOwtQYapleWnSRV3wG6nyVoJuX7uNw+mIsXufn/VvgYNcO4F92gFA6VzXFwt
         eOhUpeRgsCEnQtLmxjSeMTCe6W9cAK/t6KbwM2kgtnaA3tLSMelO4zx3Zw8S+IAE0r
         PklAtVwvV3xkY6oi0JFEiZyl/eSVsDe58EY1TNHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/667] x86/delay: Fix the wrong asm constraint in delay_loop()
Date:   Tue,  7 Jun 2022 18:57:42 +0200
Message-Id: <20220607164940.709379593@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

[ Upstream commit b86eb74098a92afd789da02699b4b0dd3f73b889 ]

The asm constraint does not reflect the fact that the asm statement can
modify the value of the local variable loops. Which it does.

Specifying the wrong constraint may lead to undefined behavior, it may
clobber random stuff (e.g. local variable, important temporary value in
regs, etc.). This is especially dangerous when the compiler decides to
inline the function and since it doesn't know that the value gets
modified, it might decide to use it from a register directly without
reloading it.

Change the constraint to "+a" to denote that the first argument is an
input and an output argument.

  [ bp: Fix typo, massage commit message. ]

Fixes: e01b70ef3eb3 ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220329104705.65256-2-ammarfaizi2@gnuweeb.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/delay.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index 65d15df6212d..0e65d00e2339 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -54,8 +54,8 @@ static void delay_loop(u64 __loops)
 		"	jnz 2b		\n"
 		"3:	dec %0		\n"
 
-		: /* we don't need output */
-		:"a" (loops)
+		: "+a" (loops)
+		:
 	);
 }
 
-- 
2.35.1



