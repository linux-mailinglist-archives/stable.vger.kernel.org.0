Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632BF4E2986
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348713AbiCUOFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348893AbiCUOEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:04:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955EE33378;
        Mon, 21 Mar 2022 07:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF3B6129A;
        Mon, 21 Mar 2022 14:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33D2C340E8;
        Mon, 21 Mar 2022 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871276;
        bh=+5XscdXFlROL7LE0XhkkVwHD8z4u39zM1wNi9pM8m7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kn9rVg5lE159ethtuUykJ2miKMCzR67Cv971xUnvF7R4yr58o8ASHNYT7cM2MF6XR
         iWVNNSTy9FssvwaIfzkNrM3/kSvyxh4AUVbr3c0HJrM6hitefPhLXNSSJ+rP5kC6Gn
         Ym61tZ2+fOGhCaO/ZgIeU2uxeIxN6I+6uhQOaZEM=
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
Subject: [PATCH 5.15 06/32] efi: fix return value of __setup handlers
Date:   Mon, 21 Mar 2022 14:52:42 +0100
Message-Id: <20220321133220.747644115@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
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
index 4c3201e290e2..ea84108035eb 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -24,7 +24,7 @@ static bool dump_properties __initdata;
 static int __init dump_properties_enable(char *arg)
 {
 	dump_properties = true;
-	return 0;
+	return 1;
 }
 
 __setup("dump_apple_properties", dump_properties_enable);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9fa86288b78a..e3df82d5d37a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -209,7 +209,7 @@ static int __init efivar_ssdt_setup(char *str)
 		memcpy(efivar_ssdt, str, strlen(str));
 	else
 		pr_warn("efivar_ssdt: name too long: %s\n", str);
-	return 0;
+	return 1;
 }
 __setup("efivar_ssdt=", efivar_ssdt_setup);
 
-- 
2.34.1



