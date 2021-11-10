Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B7144C704
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhKJSrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232764AbhKJSrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:47:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7DC961213;
        Wed, 10 Nov 2021 18:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569862;
        bh=9qeTEcK0cxC7wR+2x8uKgz1nZEgn9hsYDu8gXYVGLXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Aie/qrKcaNUO075nLDOspmtKc4UgYw479LkZbkTfYy2PKu3sPcUgwWaM7xVKz3Fq
         8dJwfrxZXJZnTQMAdbMR5P2GvfQ5ChMw9w/Jy6CQsrdTrAYd9CMqT49SDxsbkmOOtt
         5PyLtuOXkYz5RmadNGuIrbCQqx6EGs7D0fEDNMqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Petr Mladek <pmladek@suse.com>, Yi Fan <yfa@google.com>
Subject: [PATCH 4.4 08/19] printk/console: Allow to disable console output by using console="" or console=null
Date:   Wed, 10 Nov 2021 19:43:10 +0100
Message-Id: <20211110182001.529534986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
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
@@ -2032,8 +2032,15 @@ static int __init console_setup(char *st
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


