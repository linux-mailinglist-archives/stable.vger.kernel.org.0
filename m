Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4C6549823
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355576AbiFMLto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357579AbiFMLqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:46:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B97D26103;
        Mon, 13 Jun 2022 03:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81AEDB80E93;
        Mon, 13 Jun 2022 10:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC6FC34114;
        Mon, 13 Jun 2022 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117569;
        bh=8YH6x0Tqyp6rJkWOfjcRIC8Y6lDqvyPZclzyU51XQPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rysj93qJET1Pb9U3VUuDsCpyODl88gbeKjgKV00zyaFiRn9yKGn+A3R1aulDdPlkI
         13mG7y1w+q4qdLFzP6Nxl+uzhZbJ1u1OxwcZPR3bZCOJtq+ahtJ1pFZbL6pse1alKm
         kdmWrpRvtow6leceEAufXWF04w95+ZRgtukh+mgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/287] x86/delay: Fix the wrong asm constraint in delay_loop()
Date:   Mon, 13 Jun 2022 12:08:07 +0200
Message-Id: <20220613094925.781139943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index 614c2c6b1959..68ca883abfdb 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -43,8 +43,8 @@ static void delay_loop(unsigned long loops)
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



