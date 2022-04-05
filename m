Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF54F36AA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbiDELGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348309AbiDEJr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:47:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CDB6BDCA;
        Tue,  5 Apr 2022 02:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFCCDB81C85;
        Tue,  5 Apr 2022 09:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0927C385A0;
        Tue,  5 Apr 2022 09:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151218;
        bh=+8O6INW6CYRSm0dNRMe8Vhn2Otc3I/NdulKbBHar9us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Do7P9UC8Nc1cDpuEkRIW3Ds9WeEl5a2CRNbOad3/r+BfaYxMDxnqcdZ83DxtbiuzW
         0r76Lyit8npSMjV1RyW/8cXw/vHJVwvmqXmlQ2+u3mLp44rDX/4JbSKlNLgi6txRhZ
         4CtcNoMEh/ZkIKvU6EF6s6fe+x3UUwbOAXJMQPss=
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
Subject: [PATCH 5.15 337/913] printk: fix return value of printk.devkmsg __setup handler
Date:   Tue,  5 Apr 2022 09:23:19 +0200
Message-Id: <20220405070349.950252709@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 99221b016c68..7aeb13542ce7 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -146,8 +146,10 @@ static int __control_devkmsg(char *str)
 
 static int __init control_devkmsg(char *str)
 {
-	if (__control_devkmsg(str) < 0)
+	if (__control_devkmsg(str) < 0) {
+		pr_warn("printk.devkmsg: bad option string '%s'\n", str);
 		return 1;
+	}
 
 	/*
 	 * Set sysctl string accordingly:
@@ -166,7 +168,7 @@ static int __init control_devkmsg(char *str)
 	 */
 	devkmsg_log |= DEVKMSG_LOG_MASK_LOCK;
 
-	return 0;
+	return 1;
 }
 __setup("printk.devkmsg=", control_devkmsg);
 
-- 
2.34.1



