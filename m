Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8671579EF0
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbiGSNIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243066AbiGSNHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:07:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AA1B9A2E;
        Tue, 19 Jul 2022 05:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FC7B61921;
        Tue, 19 Jul 2022 12:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A2CC341C6;
        Tue, 19 Jul 2022 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233612;
        bh=NHn0yPM9W+29gfs+hlxD9lUActx7AsYKzs0vYg0YH+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgg+NwymaJGU1YIPq9wOa5HaBKNeQUFKt631VoTMY76DoEsQK5bcyQI54wfbaamkA
         UWrZe7IwiLRoFCX2TCy/583d2wFAvf7HPEIYv86tGNxRTnvwNPug8py2NYU4Sg6RXb
         OWrxpW/kN3YTFCIbkGPFm4cAAyPrXqgZwR4EvzF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 152/231] ARM: 9212/1: domain: Modify Kconfig help text
Date:   Tue, 19 Jul 2022 13:53:57 +0200
Message-Id: <20220719114727.105994758@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2bf6204240fddb22cc4940b9e3f40c538390212e ]

After the removal of set_fs() the reference to set_fs() is stale.
Alter the helptext to reflect what the config option really does.

Fixes: 8ac6f5d7f84b ("ARM: 9113/1: uaccess: remove set_fs() implementation")
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/Kconfig | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index d30ee26ccc87..6284914f4361 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -631,7 +631,11 @@ config CPU_USE_DOMAINS
 	bool
 	help
 	  This option enables or disables the use of domain switching
-	  via the set_fs() function.
+	  using the DACR (domain access control register) to protect memory
+	  domains from each other. In Linux we use three domains: kernel, user
+	  and IO. The domains are used to protect userspace from kernelspace
+	  and to handle IO-space as a special type of memory by assigning
+	  manager or client roles to running code (such as a process).
 
 config CPU_V7M_NUM_IRQ
 	int "Number of external interrupts connected to the NVIC"
-- 
2.35.1



