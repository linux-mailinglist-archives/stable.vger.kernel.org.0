Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F161F6AB532
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 05:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCFEAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 23:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCFEAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 23:00:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDACF96B;
        Sun,  5 Mar 2023 20:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4t2RLEMOsre3ySkVA5U3MuOSvkfzSwor9mXcBDVP6m8=; b=5GRK/yLBS4EPjws3juTTRzDRhv
        dAuhi0vmDk9xa6gXodg55Ao2NH+REXeVtDSM42qVtc8KRFxRInZuwQdfjzIlQuwEfhuIp8DWbOAX9
        ONpVxumYj7x+7V1kbxIrzm4qMR3Zszep1/nkMrpOVL9B/EyxiC6n1cbQZhYzN6FpZRypK7dFEQcgC
        WTIqUll/wOUdNHP0Hm0O6WiGC+WdZV9Rnn577rwvpicwfJ9DFfVfLA2k4/6ycGJenU3T431WUthEB
        X9G4TlfEPOJMCptTuWc7ogINplSUtpOkKtxS8d1cK03RjhotwJSQ9P2l6CTkhuvXssUbTGyJFJeo4
        3cqJF0lw==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pZ21j-00B9yD-3q; Mon, 06 Mar 2023 04:00:43 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org
Subject: [PATCH 7/7 v4] sh: mcount.S: fix build error when PRINTK is not enabled
Date:   Sun,  5 Mar 2023 20:00:37 -0800
Message-Id: <20230306040037.20350-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306040037.20350-1-rdunlap@infradead.org>
References: <20230306040037.20350-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a build error in mcount.S when CONFIG_PRINTK is not enabled.
Fixes this build error:

sh2-linux-ld: arch/sh/lib/mcount.o: in function `stack_panic':
(.text+0xec): undefined reference to `dump_stack'

Fixes: e460ab27b6c3 ("sh: Fix up stack overflow check with ftrace disabled.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org
---
v2: add PRINTK to STACK_DEBUG dependency (thanks, Geert)
v3: skipped
v4: refresh & resend

 arch/sh/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -15,7 +15,7 @@ config SH_STANDARD_BIOS
 
 config STACK_DEBUG
 	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && PRINTK
 	help
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit. Saying Y here will add overhead to
