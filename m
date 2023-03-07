Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664686AF42A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbjCGTOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbjCGTNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:13:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B659AD01E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C66261520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58304C433D2;
        Tue,  7 Mar 2023 18:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215459;
        bh=Yti+yycgk9tcP2aUBiteMpTCOeLRMAgDFdiR87L+80U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeqENfOXeiQgaQCG5+zcOCwxyeq/+egE8KTsx9wp52SDkte+z3+A/J+YvXqI3JbgP
         P6RkzAlIYG/k2YkogtZv52kwXGRO6VkXoIczKyTDK9ECAKrt5puO49nGNFvYlhgpjw
         B5vshAqs/13H+lPzQNCyVA7CCOYT3R9nAOK0YnwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Mladek <pmladek@suse.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/567] printf: fix errname.c list
Date:   Tue,  7 Mar 2023 18:00:05 +0100
Message-Id: <20230307165917.590045652@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0c2baf6509af1d11310ae4c1c839481a6e9a4bc4 ]

On most architectures, gcc -Wextra warns about the list of error
numbers containing both EDEADLK and EDEADLOCK:

lib/errname.c:15:67: warning: initialized field overwritten [-Woverride-init]
   15 | #define E(err) [err + BUILD_BUG_ON_ZERO(err <= 0 || err > 300)] = "-" #err
      |                                                                   ^~~
lib/errname.c:172:2: note: in expansion of macro 'E'
  172 |  E(EDEADLK), /* EDEADLOCK */
      |  ^

On parisc, a similar error happens with -ECANCELLED, which is an
alias for ECANCELED.

Make the EDEADLK printing conditional on the number being distinct
from EDEADLOCK, and remove the -ECANCELLED bit completely as it
can never be hit.

To ensure these are correct, add static_assert lines that verify
all the remaining aliases are in fact identical to the canonical
name.

Fixes: 57f5677e535b ("printf: add support for printing symbolic error names")
Cc: Petr Mladek <pmladek@suse.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Uwe Kleine-König <uwe@kleine-koenig.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/all/20210514213456.745039-1-arnd@kernel.org/
Link: https://lore.kernel.org/all/20210927123409.1109737-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230206194126.380350-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/errname.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/lib/errname.c b/lib/errname.c
index 05cbf731545f0..67739b174a8cc 100644
--- a/lib/errname.c
+++ b/lib/errname.c
@@ -21,6 +21,7 @@ static const char *names_0[] = {
 	E(EADDRNOTAVAIL),
 	E(EADV),
 	E(EAFNOSUPPORT),
+	E(EAGAIN), /* EWOULDBLOCK */
 	E(EALREADY),
 	E(EBADE),
 	E(EBADF),
@@ -31,15 +32,17 @@ static const char *names_0[] = {
 	E(EBADSLT),
 	E(EBFONT),
 	E(EBUSY),
-#ifdef ECANCELLED
-	E(ECANCELLED),
-#endif
+	E(ECANCELED), /* ECANCELLED */
 	E(ECHILD),
 	E(ECHRNG),
 	E(ECOMM),
 	E(ECONNABORTED),
+	E(ECONNREFUSED), /* EREFUSED */
 	E(ECONNRESET),
+	E(EDEADLK), /* EDEADLOCK */
+#if EDEADLK != EDEADLOCK /* mips, sparc, powerpc */
 	E(EDEADLOCK),
+#endif
 	E(EDESTADDRREQ),
 	E(EDOM),
 	E(EDOTDOT),
@@ -166,14 +169,17 @@ static const char *names_0[] = {
 	E(EUSERS),
 	E(EXDEV),
 	E(EXFULL),
-
-	E(ECANCELED), /* ECANCELLED */
-	E(EAGAIN), /* EWOULDBLOCK */
-	E(ECONNREFUSED), /* EREFUSED */
-	E(EDEADLK), /* EDEADLOCK */
 };
 #undef E
 
+#ifdef EREFUSED /* parisc */
+static_assert(EREFUSED == ECONNREFUSED);
+#endif
+#ifdef ECANCELLED /* parisc */
+static_assert(ECANCELLED == ECANCELED);
+#endif
+static_assert(EAGAIN == EWOULDBLOCK); /* everywhere */
+
 #define E(err) [err - 512 + BUILD_BUG_ON_ZERO(err < 512 || err > 550)] = "-" #err
 static const char *names_512[] = {
 	E(ERESTARTSYS),
-- 
2.39.2



