Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99162505830
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244788AbiDROAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241917AbiDRN5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:57:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30562AE15;
        Mon, 18 Apr 2022 06:07:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8643460EFC;
        Mon, 18 Apr 2022 13:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63381C385A1;
        Mon, 18 Apr 2022 13:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287234;
        bh=uKM1IrRUnR0at9+BarVT8h1V2qi4LheOzIpIvXhYmuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itfihk6X6yneFH0jn76tKD7EdmebPL4VjWoNN9AsnV0M7hkZO/tZj0foA7VypbeLZ
         DPRxH/VA39C7DH05iOnR8yYtCOHfkj6Afcnuy8M0We5k0FpAQeo38vgw4e9LbCvGWv
         UyETD6Pj5GOvwvuatrUBoXCoGQWW+uXKz6iMje1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Phil Sutter <n0-1@freewrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Daniel Walter <dwalter@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 098/218] MIPS: RB532: fix return value of __setup handler
Date:   Mon, 18 Apr 2022 14:12:44 +0200
Message-Id: <20220418121202.408882383@linuxfoundation.org>
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

[ Upstream commit 8755d57ba1ff910666572fab9e32890e8cc6ed3b ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from setup_kmac().

Fixes: 9e21c7e40b7e ("MIPS: RB532: Replace parse_mac_addr() with mac_pton().")
Fixes: 73b4390fb234 ("[MIPS] Routerboard 532: Support for base system")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
From: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Phil Sutter <n0-1@freewrt.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Daniel Walter <dwalter@google.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/rb532/devices.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index 0966adccf520..ed921f7b4364 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -313,11 +313,9 @@ static int __init plat_setup_devices(void)
 static int __init setup_kmac(char *s)
 {
 	printk(KERN_INFO "korina mac = %s\n", s);
-	if (!mac_pton(s, korina_dev0_data.mac)) {
+	if (!mac_pton(s, korina_dev0_data.mac))
 		printk(KERN_ERR "Invalid mac\n");
-		return -EINVAL;
-	}
-	return 0;
+	return 1;
 }
 
 __setup("kmac=", setup_kmac);
-- 
2.34.1



