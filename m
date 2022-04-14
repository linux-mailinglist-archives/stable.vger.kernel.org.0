Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1B8500F42
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbiDNNYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244275AbiDNNYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0109A9BAE2;
        Thu, 14 Apr 2022 06:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9DA0B82986;
        Thu, 14 Apr 2022 13:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5586C385A1;
        Thu, 14 Apr 2022 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942339;
        bh=suKIR3nBMZp01YvKLQQQ+D7fwrZ0GKpKD2JFv8dzE3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fuINFSbBzJGWbG3NYa850WCemQMZCYMjvD3dkmiIz9guEIriAzAJIlc71jl+uXpP
         Z8HzxmyLfBMqFVfLL3RM95Tj379Q4hGrhth9Ydxq9sW3v4i/okv9XSHFE7u2bjI4yT
         2WbLywSQdtCnoZ+ImBdbHM4drmWsjj1S4ywMnmkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/338] printk: fix return value of printk.devkmsg __setup handler
Date:   Thu, 14 Apr 2022 15:10:02 +0200
Message-Id: <20220414110841.715228038@linuxfoundation.org>
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

[ Upstream commit b665eae7a788c5e2bc10f9ac3c0137aa0ad1fc97 ]

If an invalid option value is used with "printk.devkmsg=<value>",
it is silently ignored.
If a valid option value is used, it is honored but the wrong return
value (0) is used, indicating that the command line option had an
error and was not handled. This string is not added to init's
environment strings due to init/main.c::unknown_bootoption()
checking for a '.' in the boot option string and then considering
that string to be an "Unused module parameter".

Print a warning message if a bad option string is used.
Always return 1 from the __setup handler to indicate that the command
line option has been handled.

Fixes: 750afe7babd1 ("printk: add kernel parameter to control writes to /dev/kmsg")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Borislav Petkov <bp@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Ogness <john.ogness@linutronix.de>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220228220556.23484-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 57742e193214..2ba16c426ba5 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -127,8 +127,10 @@ static int __control_devkmsg(char *str)
 
 static int __init control_devkmsg(char *str)
 {
-	if (__control_devkmsg(str) < 0)
+	if (__control_devkmsg(str) < 0) {
+		pr_warn("printk.devkmsg: bad option string '%s'\n", str);
 		return 1;
+	}
 
 	/*
 	 * Set sysctl string accordingly:
@@ -147,7 +149,7 @@ static int __init control_devkmsg(char *str)
 	 */
 	devkmsg_log |= DEVKMSG_LOG_MASK_LOCK;
 
-	return 0;
+	return 1;
 }
 __setup("printk.devkmsg=", control_devkmsg);
 
-- 
2.34.1



