Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE334F25C5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiDEHwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiDEHsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:48:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD7B631F;
        Tue,  5 Apr 2022 00:46:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 161B3615E7;
        Tue,  5 Apr 2022 07:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0B3C34112;
        Tue,  5 Apr 2022 07:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144802;
        bh=1NernAKoOBfJpA9BgdskRZGyX2V/8ZAUyEvP77Lq5xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOuyyO9gHivJpXpeIkelemLariomzfuuf/9iEZcdAbZOsJ+a/AwrTEH0T0GDvfD3P
         6SfESF5sS4Sa5k4iOCIloJjT3dIYhPm2rfLd2OCVHsPLbfI3UERcckYCFR6syLXqTa
         rJ9bJvR8cKglBwoGlzmbSyu6sWhWj2EHYJWBbILE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.17 0175/1126] mips: Always permit to build u-boot images
Date:   Tue,  5 Apr 2022 09:15:22 +0200
Message-Id: <20220405070412.739084859@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

commit 34275ac292ae141ebc1296b72f005f71b25998a7 upstream.

The platforms where the kernel should be loaded above 0x8000.0000 do not
support loading u-boot images, that doesn't mean that we shouldn't be
able to generate them.

Additionally, since commit 79876cc1d7b8 ("MIPS: new Kconfig option
ZBOOT_LOAD_ADDRESS"), the $(zload-y) variable was no longer hardcoded,
which made it impossible to use the uzImage.bin target.

Fixes: 79876cc1d7b8 ("MIPS: new Kconfig option ZBOOT_LOAD_ADDRESS")
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -340,14 +340,12 @@ drivers-$(CONFIG_PM)	+= arch/mips/power/
 boot-y			:= vmlinux.bin
 boot-y			+= vmlinux.ecoff
 boot-y			+= vmlinux.srec
-ifeq ($(shell expr $(load-y) \< 0xffffffff80000000 2> /dev/null), 0)
 boot-y			+= uImage
 boot-y			+= uImage.bin
 boot-y			+= uImage.bz2
 boot-y			+= uImage.gz
 boot-y			+= uImage.lzma
 boot-y			+= uImage.lzo
-endif
 boot-y			+= vmlinux.itb
 boot-y			+= vmlinux.gz.itb
 boot-y			+= vmlinux.bz2.itb
@@ -359,9 +357,7 @@ bootz-y			:= vmlinuz
 bootz-y			+= vmlinuz.bin
 bootz-y			+= vmlinuz.ecoff
 bootz-y			+= vmlinuz.srec
-ifeq ($(shell expr $(zload-y) \< 0xffffffff80000000 2> /dev/null), 0)
 bootz-y			+= uzImage.bin
-endif
 bootz-y			+= vmlinuz.itb
 
 #


