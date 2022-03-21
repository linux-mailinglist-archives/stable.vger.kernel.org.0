Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5137E4E28CB
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348541AbiCUOAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348944AbiCUN6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA04160140;
        Mon, 21 Mar 2022 06:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E664FB81598;
        Mon, 21 Mar 2022 13:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB84C340F2;
        Mon, 21 Mar 2022 13:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871003;
        bh=xtTh4I9hVgdpR1VDucgu0Zv5fcwvFPkzhUf7+w9kffs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGN3zof5/LYJ1j2RBy5QBIRbl87xwjR2jWov0Jx0RusR2qloVPaITVYdIq8sClsIZ
         17XXBrsNcgObcDMcepvtcaz5JdZvnLWVbnlmhPw67xel5XyHKt0cfPKrL+No2lcJ+N
         J6f5X7vpUFCd0UxqhAV4eO5pNASEcM9ANtwcYRZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>,
        Octavian Purdila <octavian.purdila@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/57] efi: fix return value of __setup handlers
Date:   Mon, 21 Mar 2022 14:52:28 +0100
Message-Id: <20220321133223.354570592@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 9feaf8b387ee0ece9c1d7add308776b502a35d0c ]

When "dump_apple_properties" is used on the kernel boot command line,
it causes an Unknown parameter message and the string is added to init's
argument strings:

  Unknown kernel command line parameters "dump_apple_properties
    BOOT_IMAGE=/boot/bzImage-517rc6 efivar_ssdt=newcpu_ssdt", will be
    passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
     dump_apple_properties
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc6
     efivar_ssdt=newcpu_ssdt

Similarly when "efivar_ssdt=somestring" is used, it is added to the
Unknown parameter message and to init's environment strings, polluting
them (see examples above).

Change the return value of the __setup functions to 1 to indicate
that the __setup options have been handled.

Fixes: 58c5475aba67 ("x86/efi: Retrieve and assign Apple device properties")
Fixes: 475fb4e8b2f4 ("efi / ACPI: load SSTDs from EFI variables")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Link: https://lore.kernel.org/r/20220301041851.12459-1-rdunlap@infradead.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/apple-properties.c | 2 +-
 drivers/firmware/efi/efi.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 60a95719ecb8..726a23d45da4 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -34,7 +34,7 @@ static bool dump_properties __initdata;
 static int __init dump_properties_enable(char *arg)
 {
 	dump_properties = true;
-	return 0;
+	return 1;
 }
 
 __setup("dump_apple_properties", dump_properties_enable);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index a8180f9090fa..7098744f9276 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -245,7 +245,7 @@ static int __init efivar_ssdt_setup(char *str)
 		memcpy(efivar_ssdt, str, strlen(str));
 	else
 		pr_warn("efivar_ssdt: name too long: %s\n", str);
-	return 0;
+	return 1;
 }
 __setup("efivar_ssdt=", efivar_ssdt_setup);
 
-- 
2.34.1



