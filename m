Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D344CF5B6
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbiCGJad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbiCGJ2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BDE5B3E4;
        Mon,  7 Mar 2022 01:25:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 818C16116F;
        Mon,  7 Mar 2022 09:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB8CC340E9;
        Mon,  7 Mar 2022 09:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645105;
        bh=AhXUlbjfx1RQm61Vv2Eqw9hgtDpyAwoe9JDwySpQJVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcYNqduRcJEYUqtCGrVulAWARHg+quJVMMP9P3wFLUlenU3e/hC+ujPFHc/uEqk4g
         R//WU58pYjsSSMzSoYMcM0B8tdS4pwLr9IHD8RGPJPSqmz3fbPz5VE9GyxOqMIEfIq
         KlmwHIGW+zvDnuViW8nvw8bGnD77o/zVbW6YPmAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, patches@armlinux.org.uk,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 40/51] ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions
Date:   Mon,  7 Mar 2022 10:19:15 +0100
Message-Id: <20220307091638.132975931@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 7b83299e5b9385943a857d59e15cba270df20d7e upstream.

early_param() handlers should return 0 on success.
__setup() handlers should return 1 on success, i.e., the parameter
has been handled. A return of 0 would cause the "option=value" string
to be added to init's environment strings, polluting it.

../arch/arm/mm/mmu.c: In function 'test_early_cachepolicy':
../arch/arm/mm/mmu.c:215:1: error: no return statement in function returning non-void [-Werror=return-type]
../arch/arm/mm/mmu.c: In function 'test_noalign_setup':
../arch/arm/mm/mmu.c:221:1: error: no return statement in function returning non-void [-Werror=return-type]

Fixes: b849a60e0903 ("ARM: make cr_alignment read-only #ifndef CONFIG_CPU_CP15")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: patches@armlinux.org.uk
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -230,12 +230,14 @@ early_param("ecc", early_ecc);
 static int __init early_cachepolicy(char *p)
 {
 	pr_warn("cachepolicy kernel parameter not supported without cp15\n");
+	return 0;
 }
 early_param("cachepolicy", early_cachepolicy);
 
 static int __init noalign_setup(char *__unused)
 {
 	pr_warn("noalign kernel parameter not supported without cp15\n");
+	return 1;
 }
 __setup("noalign", noalign_setup);
 


