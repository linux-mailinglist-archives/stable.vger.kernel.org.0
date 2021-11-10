Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6983F44C711
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhKJSr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232830AbhKJSr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:47:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 342DB61247;
        Wed, 10 Nov 2021 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569880;
        bh=1Gqceegm+1GqYddfAlC4grL9S7yABjfoSrKw2KQ4diI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6e/kBAf5PvU9fWBABL1uj35eiAi4QT2NeUYYQ2qIigkOE2XwxlEp3iQSP/o4Z1yN
         wYJv6OdfzHYSRaZldG6VI7hhCebnUzYwweT+DIvZKQBF8Eq5xspH0fleoMrNe2x0mJ
         voBSxt7Ma99/0w4PaS0m8W9denhkG794ZGYdPtHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Petr Mladek <pmladek@suse.com>, Yi Fan <yfa@google.com>
Subject: [PATCH 4.9 13/22] printk/console: Allow to disable console output by using console="" or console=null
Date:   Wed, 10 Nov 2021 19:43:20 +0100
Message-Id: <20211110182002.007984115@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
References: <20211110182001.579561273@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

commit 3cffa06aeef7ece30f6b5ac0ea51f264e8fea4d0 upstream.

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
Cc: Yi Fan <yfa@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/printk/printk.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2035,8 +2035,15 @@ static int __init console_setup(char *st
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


