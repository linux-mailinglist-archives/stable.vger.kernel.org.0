Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A429C55853B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbiFWRyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiFWRw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:52:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5857C9214F;
        Thu, 23 Jun 2022 10:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7219B61DB3;
        Thu, 23 Jun 2022 17:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F24C3411B;
        Thu, 23 Jun 2022 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004423;
        bh=oD21TKpBLNIfhdnGC4USn4S/vNQfcl7mQO9P0WEySEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAA+Fl0SshOqUJmzMHppfTObN6tBKpqmsw76IIqO1giL2NQspUncQZI/scjt77B/r
         O9mIDLqLlcyRvUeavOpYGUmM7vOq5UhoYSaxUy+gkzbO5HyVkyrYD7U8VA0B5tbwrc
         nzKgLSRjy8CXfuD2G2kd1ATbP0oY3h/8RWSzL9Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 032/234] random: remove some dead code of poolinfo
Date:   Thu, 23 Jun 2022 18:41:39 +0200
Message-Id: <20220623164343.974428687@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

commit 09a6d00a42ce0e63e2a15be3d070974bcc656ec7 upstream.

Since it is not being used, so delete it.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-5-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -431,36 +431,6 @@ static const struct poolinfo {
 	/* was: x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 */
 	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
 	{ S(128),	104,	76,	51,	25,	1 },
-	/* was: x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 */
-	/* x^32 + x^26 + x^19 + x^14 + x^7 + x + 1 */
-	{ S(32),	26,	19,	14,	7,	1 },
-#if 0
-	/* x^2048 + x^1638 + x^1231 + x^819 + x^411 + x + 1  -- 115 */
-	{ S(2048),	1638,	1231,	819,	411,	1 },
-
-	/* x^1024 + x^817 + x^615 + x^412 + x^204 + x + 1 -- 290 */
-	{ S(1024),	817,	615,	412,	204,	1 },
-
-	/* x^1024 + x^819 + x^616 + x^410 + x^207 + x^2 + 1 -- 115 */
-	{ S(1024),	819,	616,	410,	207,	2 },
-
-	/* x^512 + x^411 + x^308 + x^208 + x^104 + x + 1 -- 225 */
-	{ S(512),	411,	308,	208,	104,	1 },
-
-	/* x^512 + x^409 + x^307 + x^206 + x^102 + x^2 + 1 -- 95 */
-	{ S(512),	409,	307,	206,	102,	2 },
-	/* x^512 + x^409 + x^309 + x^205 + x^103 + x^2 + 1 -- 95 */
-	{ S(512),	409,	309,	205,	103,	2 },
-
-	/* x^256 + x^205 + x^155 + x^101 + x^52 + x + 1 -- 125 */
-	{ S(256),	205,	155,	101,	52,	1 },
-
-	/* x^128 + x^103 + x^78 + x^51 + x^27 + x^2 + 1 -- 70 */
-	{ S(128),	103,	78,	51,	27,	2 },
-
-	/* x^64 + x^52 + x^39 + x^26 + x^14 + x + 1 -- 15 */
-	{ S(64),	52,	39,	26,	14,	1 },
-#endif
 };
 
 /*


