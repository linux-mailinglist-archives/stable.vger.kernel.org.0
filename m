Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8750155F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345618AbiDNNxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345112AbiDNNpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1DF2F000;
        Thu, 14 Apr 2022 06:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BE2EB82968;
        Thu, 14 Apr 2022 13:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC076C385A1;
        Thu, 14 Apr 2022 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943723;
        bh=ZVmDmmOcyD/n4hyXks1S0zNHFQzx5OWlZINxrVdHSdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWG0gk8mLxu1KDCRaJNy2eJi6fO7RwMXxq7nTO/VqntJzdEUHUEd3Ew5n+xzzHzld
         WnojhgioHk6rZ+/L5RjZjyPZEOvFX1N+3dfEkOL6Nbl6ptWZYHX6IV34ZwSMr+DJh/
         L7AsezaWiIJulY1QIjgs46IaJTdMSm9q3G9Brzfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 257/475] kgdbts: fix return value of __setup handler
Date:   Thu, 14 Apr 2022 15:10:42 +0200
Message-Id: <20220414110902.303177714@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

[ Upstream commit 96c9e802c64014a7716865332d732cc9c7f24593 ]

__setup() handlers should return 1 to indicate that the boot option
has been handled. A return of 0 causes the boot option/value to be
listed as an Unknown kernel parameter and added to init's (limited)
environment strings. So return 1 from kgdbts_option_setup().

Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc7
  kgdboc=kbd kgdbts=", will be passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc7
     kgdboc=kbd
     kgdbts=

Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: e8d31c204e36 ("kgdb: add kgdb internal test suite")
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20220308033255.22118-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/kgdbts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 8d18f19c99c4..2f8858105733 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -1060,10 +1060,10 @@ static int kgdbts_option_setup(char *opt)
 {
 	if (strlen(opt) >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdbts: config string too long\n");
-		return -ENOSPC;
+		return 1;
 	}
 	strcpy(config, opt);
-	return 0;
+	return 1;
 }
 
 __setup("kgdbts=", kgdbts_option_setup);
-- 
2.34.1



