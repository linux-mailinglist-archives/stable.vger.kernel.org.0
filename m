Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ABB44B0B4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 16:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbhKIP4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 10:56:13 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:36434 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbhKIP4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 10:56:13 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 75D8521B1B;
        Tue,  9 Nov 2021 15:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636473206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=X3MM7A8ZGk2V92RPG18+Ia7HOOHXI7EShA0+rrV/h04=;
        b=N0c51wVyTr0Ytxxc7QJrCIuQ4LMuA3C0a/RMC4guv4jkXh2x6u0DcIvi3hsDP/1upLSRwG
        QsFb2E6/0efP5fPZpiZ+AZjRap7OGmjvO2wyX6eWwekpOn/7bSXhNfi0WNzIljca8HFsWg
        iFRMN3qqgzHkLMIyV0eeKkmk86OI+28=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 58003A3B81;
        Tue,  9 Nov 2021 15:53:26 +0000 (UTC)
Date:   Tue, 9 Nov 2021 16:53:26 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>
Cc:     Yi Fan <yfa@google.com>, shreyas.joshi@biamp.com,
        Joshua Levasseur <jlevasseur@google.com>, sashal@kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] printk/console: Allow to disable console output by using
 console="" or console=null
Message-ID: <YYqZdkLBAC8mtRSC@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 48021f98130880dd74 ("printk: handle blank console arguments
passed in.") prevented crash caused by empty console= parameter value.

Unfortunately, this value is widely used on Chromebooks to disable
the console output. The above commit caused performance regression
because the messages were pushed on slow console even though nobody
was watching it.

Use ttynull driver explicitly for console="" and console=null
parameters. It has been created for exactly this purpose.

It causes that preferred_console is set. As a result, ttySX and ttyX
are not used as a fallback. And only ttynull console gets registered by
default.

It still allows to register other consoles either by additional console=
parameters or SPCR. It prevents regression because it worked this way even
before. Also it is a sane semantic. Preventing output on all consoles
should be done another way, for example, by introducing mute_console
parameter.

Link: https://lore.kernel.org/r/20201006025935.GA597@jagdpanzerIV.localdomain
Suggested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20201111135450.11214-3-pmladek@suse.com
---

This is backport of the commit 3cffa06aeef7ece30f6b5ac0e
("printk/console: Allow to disable console output by using
console="" or console=null") for stable release:

    + 4.4, 4.9, 4.14, 4.19, 5.4

Please, use the original upstream commit for stable release:

   + 5.10

It should fix the problem reported at
https://www.spinics.net/lists/stable/msg509616.html

kernel/printk/printk.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b55dfb3e801f..6d3e1f4961fb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2032,8 +2032,15 @@ static int __init console_setup(char *str)
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
-	if (str[0] == 0)
+	/*
+	 * console="" or console=null have been suggested as a way to
+	 * disable console output. Use ttynull that has been created
+	 * for exacly this purpose.
+	 */
+	if (str[0] == 0 || strcmp(str, "null") == 0) {
+		__add_preferred_console("ttynull", 0, NULL, NULL);
 		return 1;
+	}
 
 	if (_braille_console_setup(&str, &brl_options))
 		return 1;
-- 
2.26.2

