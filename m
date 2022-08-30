Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8C95A6D5E
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 21:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiH3T3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 15:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiH3T3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 15:29:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E6118F;
        Tue, 30 Aug 2022 12:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FmXMyfkv+KJwquk3Ym2dRCy8lE94SxbT4v5prlR2Cfk=; b=FnLdNwEjTp6E3MjZE8D9jjehqU
        t+FtL2aUBDQ1EJSKrhdO8N1JK9IieSQLKURzQ5xZxvw3qJyqar9lSZ6aIpEvh2wBfn6p4c4wG6wSK
        Czj90DhU1rNRhqFdxBMyR6w1cA2lOLQYxKO0G2b47tO3ULtsCN7uR+YorOLNvuXTz6mhksOPPOjMX
        22oUrm6PnGJYmG7T27pW6aYemzyeWgjvm7AbZ5S6JOccR6SFcTt+zpObWEjCp/qeV/NVSnhv1xuvR
        Yi7qw5GsDuN4eAuiOOfrZkhv1TXbjBd9ol84NG4RNMoOL1BLGZvEXbqIODonT773Hg1ZhOfoHwdhL
        K1hZZAJw==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oT6vA-004MYf-E4; Tue, 30 Aug 2022 19:29:12 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] sparc64: NMI watchdog: fix return value of __setup handler
Date:   Tue, 30 Aug 2022 12:29:06 -0700
Message-Id: <20220830192906.31757-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from setup_nmi_watchdog().

Fixes: e5553a6d0442 ("sparc64: Implement NMI watchdog on capable cpus.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
---
v2: change From" Igor to Reported-by:
    add more Cc's

 arch/sparc/kernel/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -274,7 +274,7 @@ static int __init setup_nmi_watchdog(cha
 	if (!strncmp(str, "panic", 5))
 		panic_on_timeout = 1;
 
-	return 0;
+	return 1;
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
