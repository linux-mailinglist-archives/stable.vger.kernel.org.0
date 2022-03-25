Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4886B4E7737
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355875AbiCYP12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377444AbiCYPYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1469E7299;
        Fri, 25 Mar 2022 08:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25FCBCE2A45;
        Fri, 25 Mar 2022 15:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3731EC340E9;
        Fri, 25 Mar 2022 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221478;
        bh=3snGlK3kA7ZUY+R0MwdxzWSgKKQaA0DAwJcsXL42dfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtBfHu5j/UOVSk9k2g9ixAFOYRaF93W9i6wafbqaoz8iD68LYUKITk6nRoTJEhREr
         gck8wjvQJVHJwVIeVpOiryfrFnG3JsfnyLoIVKGqjjEfe/mgqAqtMGMU6aK+xgBt+A
         ru4lUJdnJ1aRAIfw2FoRZYJeeTwMdRAuH8/WSX1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.16 37/37] nds32: fix access_ok() checks in get/put_user
Date:   Fri, 25 Mar 2022 16:14:47 +0100
Message-Id: <20220325150421.106820241@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 8926d88ced46700bf6117ceaf391480b943ea9f4 upstream.

The get_user()/put_user() functions are meant to check for
access_ok(), while the __get_user()/__put_user() functions
don't.

This broke in 4.19 for nds32, when it gained an extraneous
check in __get_user(), but lost the check it needs in
__put_user().

Fixes: 487913ab18c2 ("nds32: Extract the checking and getting pointer to a macro")
Cc: stable@vger.kernel.org @ v4.19+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nds32/include/asm/uaccess.h |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/arch/nds32/include/asm/uaccess.h
+++ b/arch/nds32/include/asm/uaccess.h
@@ -70,9 +70,7 @@ static inline void set_fs(mm_segment_t f
  * versions are void (ie, don't return a value as such).
  */
 
-#define get_user	__get_user					\
-
-#define __get_user(x, ptr)						\
+#define get_user(x, ptr)						\
 ({									\
 	long __gu_err = 0;						\
 	__get_user_check((x), (ptr), __gu_err);				\
@@ -85,6 +83,14 @@ static inline void set_fs(mm_segment_t f
 	(void)0;							\
 })
 
+#define __get_user(x, ptr)						\
+({									\
+	long __gu_err = 0;						\
+	const __typeof__(*(ptr)) __user *__p = (ptr);			\
+	__get_user_err((x), __p, (__gu_err));				\
+	__gu_err;							\
+})
+
 #define __get_user_check(x, ptr, err)					\
 ({									\
 	const __typeof__(*(ptr)) __user *__p = (ptr);			\
@@ -165,12 +171,18 @@ do {									\
 		: "r"(addr), "i"(-EFAULT)				\
 		: "cc")
 
-#define put_user	__put_user					\
+#define put_user(x, ptr)						\
+({									\
+	long __pu_err = 0;						\
+	__put_user_check((x), (ptr), __pu_err);				\
+	__pu_err;							\
+})
 
 #define __put_user(x, ptr)						\
 ({									\
 	long __pu_err = 0;						\
-	__put_user_err((x), (ptr), __pu_err);				\
+	__typeof__(*(ptr)) __user *__p = (ptr);				\
+	__put_user_err((x), __p, __pu_err);				\
 	__pu_err;							\
 })
 


