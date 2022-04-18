Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57578505901
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343936AbiDRONq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344620AbiDROKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:10:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CDF3702B;
        Mon, 18 Apr 2022 06:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61897B80EE2;
        Mon, 18 Apr 2022 13:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CABEC385A1;
        Mon, 18 Apr 2022 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287453;
        bh=y0nY1AxcVH6qREXVvFRbjPUxs41iCOgXpjvkKiZmOZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQr2jS5AX7bgf3+vQ3eSN9t1kgcFBs9RN1Bsjuqf5wmcDnqEe5dIj2cuU5uPtRKez
         st5TGp+4mgshW2ILo2Y3EzS4dQDnpXYrlTloM5zIoUQ3innVKXTgVI+8oybLkC56rU
         Ur/oma8rshOgs1pPgFguouJZlzz02fi7GKvXQJjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@armlinux.org.uk,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 164/218] ARM: 9187/1: JIVE: fix return value of __setup handler
Date:   Mon, 18 Apr 2022 14:13:50 +0200
Message-Id: <20220418121204.963691045@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8b2360c7157b462c4870d447d1e65d30ef31f9aa ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from jive_mtdset().

Fixes: 9db829f485c5 ("[ARM] JIVE: Initial machine support for Logitech Jive")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: patches@armlinux.org.uk
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-s3c24xx/mach-jive.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index 7d99fe8f6157..5d43733ee7d6 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -240,11 +240,11 @@ static int __init jive_mtdset(char *options)
 	unsigned long set;
 
 	if (options == NULL || options[0] == '\0')
-		return 0;
+		return 1;
 
 	if (kstrtoul(options, 10, &set)) {
 		printk(KERN_ERR "failed to parse mtdset=%s\n", options);
-		return 0;
+		return 1;
 	}
 
 	switch (set) {
@@ -259,7 +259,7 @@ static int __init jive_mtdset(char *options)
 		       "using default.", set);
 	}
 
-	return 0;
+	return 1;
 }
 
 /* parse the mtdset= option given to the kernel command line */
-- 
2.35.1



