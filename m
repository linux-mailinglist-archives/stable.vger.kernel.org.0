Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5F36AB52B
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 05:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjCFEAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 23:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFEAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 23:00:42 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2325AF74B;
        Sun,  5 Mar 2023 20:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=q4i2L9mFgoWjrsHlBXky+D6dbfsBgFxhqp15flWkw9k=; b=2Fzol0PcE0ZfGAK4Yenf3qfW1z
        zwKzKQ8wu4rEHZme/FrfCmoqKeW4wUil7Fj8RApgHgpJLePU+ThWlt03qdxhURSc20gxd+xqt8Hx3
        f9GW2U76lHsp8McuSzwMfu/ehyP1f6TuFRBXyQcjgWHzsk5vx8SOd7uXIOcNUGDhnDw7LIIb3yPqO
        ZJvoLp06YlqmwKlzSweL9C5CU0tXH9MXAE6FLl1y/Z1wdPBXk7zMih+VKWjZsJS5soEkEvIbtYki1
        42imzvQdXwiDJrHUlkgJgabfcDO4jzA3GTMAyS28aUnZspWNoDA7sYxk1kGNJVT86YC7qrwtDZViB
        F1zPvhDw==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pZ21g-00B9yD-GM; Mon, 06 Mar 2023 04:00:40 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <izh1979@gmail.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/7 v4] sh: nmi_debug: fix return value of __setup handler
Date:   Sun,  5 Mar 2023 20:00:32 -0800
Message-Id: <20230306040037.20350-3-rdunlap@infradead.org>
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

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from nmi_debug_setup().

Fixes: 1e1030dccb10 ("sh: nmi_debug support.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Cc: stable@vger.kernel.org
---
v2: add more Cc's;
    refresh and resend;
v3: add Arnd to Cc: list
v4: update Cc: list, refresh & resend

 arch/sh/kernel/nmi_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -- a/arch/sh/kernel/nmi_debug.c b/arch/sh/kernel/nmi_debug.c
--- a/arch/sh/kernel/nmi_debug.c
+++ b/arch/sh/kernel/nmi_debug.c
@@ -49,7 +49,7 @@ static int __init nmi_debug_setup(char *
 	register_die_notifier(&nmi_debug_nb);
 
 	if (*str != '=')
-		return 0;
+		return 1;
 
 	for (p = str + 1; *p; p = sep + 1) {
 		sep = strchr(p, ',');
@@ -70,6 +70,6 @@ static int __init nmi_debug_setup(char *
 			break;
 	}
 
-	return 0;
+	return 1;
 }
 __setup("nmi_debug", nmi_debug_setup);
