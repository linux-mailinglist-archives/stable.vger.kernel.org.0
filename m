Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D9E4D3EFF
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 02:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiCJByx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 20:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiCJByw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 20:54:52 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245FC128592;
        Wed,  9 Mar 2022 17:53:53 -0800 (PST)
Received: from integral2.. (unknown [114.10.7.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 138147E2D7;
        Thu, 10 Mar 2022 01:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646877232;
        bh=k4b/gnTPXj7jVItm9sqkob63bVPtxz95JpsUqhVzIvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJ9w89Xw36tW+P7fsFcWottfGTayDR72m4AEw+oygIZnUbrHJXoITtxAgjU5tkW4E
         Uh5aqucDJd74GzwLm/RZ2vJLjiWHqIwkotxVdSr8iSnefl96NsEeXNy8ioWSfK9TPT
         CcZf25Unrb8Ma4+ovJaFJ1yK8qg52lUt1WyNAOutCYgtrckvc80t9vYqE+K+eZiJiM
         Cdb5PsDDnAXhXvVHDestgGZjGqyQwlh/3cwqHI5ODq8DrPn/QTt9RWEpT45WYzN2Va
         6YlGszkZWVHxI31eN0lKD9fQolTt56irJGg2A/RzjvChgHP5mQ/Gh/Q2dXeviID6dT
         ZIo8h0n/ZEWnA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        Jiri Hladky <hladky.jiri@googlemail.com>
Subject: [PATCH v5 1/2] x86/delay: Fix the wrong asm constraint in `delay_loop()`
Date:   Thu, 10 Mar 2022 08:53:05 +0700
Message-Id: <20220310015306.445359-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The asm constraint does not reflect that the asm statement can modify
the value of @loops. But the asm statement in delay_loop() does modify
the @loops.

Specifiying the wrong constraint may lead to undefined behavior, it may
clobber random stuff (e.g. local variable, important temporary value in
regs, etc.).

Fix this by changing the constraint from "a" (as an input) to "+a" (as
an input and output).

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Hladky <hladky.jiri@googlemail.com>
Cc: stable@vger.kernel.org # v2.6.27+
Fixes: e01b70ef3eb ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
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
2.32.0

