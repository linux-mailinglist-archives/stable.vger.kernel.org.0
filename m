Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38BB501556
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244909AbiDNNnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344020AbiDNNaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A915B92D0B;
        Thu, 14 Apr 2022 06:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BB87B8296A;
        Thu, 14 Apr 2022 13:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D2AC385A5;
        Thu, 14 Apr 2022 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942782;
        bh=ITigphVQFmh5JxYzbL8+UnueKu6Qw9t5JBKsneFXQbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEUZWcYdRv2X+dk3Ln/DVktNtYUesTcfCuQ9OVQGWdp+P09fuLa2VnpKmfafqOBwh
         PFIzjUs1aib2GZhbc+2rFved81QgTXonlxMydV3ykubRrGF2deiAOfvgAAqHGyioGv
         Sby0L3EdLHR+Q2nfcnJ4nOGz7ikBHSfxLIaIF+WM=
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
Subject: [PATCH 4.19 259/338] ARM: 9187/1: JIVE: fix return value of __setup handler
Date:   Thu, 14 Apr 2022 15:12:42 +0200
Message-Id: <20220414110846.261453214@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 885e8f12e4b9..eedc9f8ed210 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -237,11 +237,11 @@ static int __init jive_mtdset(char *options)
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
@@ -256,7 +256,7 @@ static int __init jive_mtdset(char *options)
 		       "using default.", set);
 	}
 
-	return 0;
+	return 1;
 }
 
 /* parse the mtdset= option given to the kernel command line */
-- 
2.35.1



