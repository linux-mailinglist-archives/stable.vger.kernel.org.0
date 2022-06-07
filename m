Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE995412DB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357046AbiFGTyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358553AbiFGTwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3CB16A27F;
        Tue,  7 Jun 2022 11:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C46B82182;
        Tue,  7 Jun 2022 18:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CABC385A2;
        Tue,  7 Jun 2022 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626060;
        bh=mPjFnB12v9QIjvkloTIVfkJB+ZjteATQWCqedBdGsPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWT5zXpI+GuPCz8tp5LZhHpD5bYcGjkSUCWZlRfLh1BUSY5fh4re1CO99WPRsms56
         FN/hKslbjJQSgumDExGySau8fQUOHD4IgOOtE+QxR7+4VlYgzDP7ekzGaBFf6jHlN9
         ecvqAHOjcDKwFHUCztiH2888wV4I+VR63StajnSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 242/772] x86/delay: Fix the wrong asm constraint in delay_loop()
Date:   Tue,  7 Jun 2022 18:57:14 +0200
Message-Id: <20220607164956.159200587@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



