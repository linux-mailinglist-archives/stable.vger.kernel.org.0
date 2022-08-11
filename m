Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E30C59000F
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiHKPgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbiHKPfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:35:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C8A9925B;
        Thu, 11 Aug 2022 08:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 161DDB82165;
        Thu, 11 Aug 2022 15:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9991C433D7;
        Thu, 11 Aug 2022 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231975;
        bh=ibPz3/kfU5FwqL/Jn2/MvmkAei/qwkLTQ9MhEGzmKqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=da5j1YexMWGMWfIcTZWJ3yAGYJS+1pIrr6jadZa7dPsvVuokFzkiiJPNk4R/taAAw
         ovlseNr+XEOmZympiM3SmhiWEUkrPFIQ6oOOD1KZszDjrpYHoFFxbD13pGdw7OpK/C
         j2b3hJSJqCLOA9F20RyHz+eAtwLJKeC2rWGyDUO7pJhSpH/zz6Z8X/1p7mLg4KdDC+
         r7a+PhsTal3H+NYmhaSepNI+xMMpVzXTf0TU66qgz1i0mT3Hq+NJRgPgob+fYJ5cCJ
         DUW2a6HUPWINO6RGYRWo4xqH11QQh24t23rkx53F/w+NRkPlwUBrtfTfD1ALcMqdol
         nEtiARFk3AQfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Willy Tarreau <w@1wt.eu>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.19 036/105] tools/nolibc/stdlib: Support overflow checking for older compiler versions
Date:   Thu, 11 Aug 2022 11:27:20 -0400
Message-Id: <20220811152851.1520029-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

[ Upstream commit 1ef150cf40be986747c3fa0c0e75acaec412e85e ]

Previously, we used __builtin_mul_overflow() to check for overflow in
the multiplication operation in the calloc() function. However, older
compiler versions don't support this built-in. This patch changes the
overflow checking mechanism to make it work on any compiler version
by using a division method to check for overflow. No functional change
intended. While in there, remove the unused variable `void *orig`.

Link: https://lore.kernel.org/lkml/20220330024114.GA18892@1wt.eu
Suggested-by: Willy Tarreau <w@1wt.eu>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Acked-by: Willy Tarreau <w@1wt.eu>
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdlib.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/include/nolibc/stdlib.h b/tools/include/nolibc/stdlib.h
index 8fd32eaf8037..92378c4b9660 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -128,10 +128,9 @@ void *malloc(size_t len)
 static __attribute__((unused))
 void *calloc(size_t size, size_t nmemb)
 {
-	void *orig;
-	size_t res = 0;
+	size_t x = size * nmemb;
 
-	if (__builtin_expect(__builtin_mul_overflow(nmemb, size, &res), 0)) {
+	if (__builtin_expect(size && ((x / size) != nmemb), 0)) {
 		SET_ERRNO(ENOMEM);
 		return NULL;
 	}
@@ -140,7 +139,7 @@ void *calloc(size_t size, size_t nmemb)
 	 * No need to zero the heap, the MAP_ANONYMOUS in malloc()
 	 * already does it.
 	 */
-	return malloc(res);
+	return malloc(x);
 }
 
 static __attribute__((unused))
-- 
2.35.1

