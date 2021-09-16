Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD3240E8C2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356153AbhIPRpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355720AbhIPRmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EB5F6326F;
        Thu, 16 Sep 2021 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811252;
        bh=rWNi77wSCjZjarPicrsk0idQ5DGpAWrXi7WaW93lZ6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9/lWzZ01pUVT16J9onRCDvMHXKlIFjYzQ091jqL/L9GHbd4qg/hUeW+Uozimsamt
         n4av3v4+2CIcUCRsFivMvsmjxdEjwmXm0Uil/NFIsVXOPwo7JJsMA6yfIwPX/ZkDg7
         ly6HvFUP28YxUS+AR1z4bl49zLklGWN98DbHHQIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.14 413/432] lib/test_stackinit: Fix static initializer test
Date:   Thu, 16 Sep 2021 18:02:42 +0200
Message-Id: <20210916155824.836497303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit f9398f15605a50110bf570aaa361163a85113dd1 upstream.

The static initializer test got accidentally converted to a dynamic
initializer. Fix this and retain the giant padding hole without using
an aligned struct member.

Fixes: 50ceaa95ea09 ("lib: Introduce test_stackinit module")
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210723221933.3431999-2-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_stackinit.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/lib/test_stackinit.c
+++ b/lib/test_stackinit.c
@@ -67,10 +67,10 @@ static bool range_contains(char *haystac
 #define INIT_STRUCT_none		/**/
 #define INIT_STRUCT_zero		= { }
 #define INIT_STRUCT_static_partial	= { .two = 0, }
-#define INIT_STRUCT_static_all		= { .one = arg->one,		\
-					    .two = arg->two,		\
-					    .three = arg->three,	\
-					    .four = arg->four,		\
+#define INIT_STRUCT_static_all		= { .one = 0,			\
+					    .two = 0,			\
+					    .three = 0,			\
+					    .four = 0,			\
 					}
 #define INIT_STRUCT_dynamic_partial	= { .two = arg->two, }
 #define INIT_STRUCT_dynamic_all		= { .one = arg->one,		\
@@ -84,8 +84,7 @@ static bool range_contains(char *haystac
 					var.one = 0;			\
 					var.two = 0;			\
 					var.three = 0;			\
-					memset(&var.four, 0,		\
-					       sizeof(var.four))
+					var.four = 0
 
 /*
  * @name: unique string name for the test
@@ -210,18 +209,13 @@ struct test_small_hole {
 	unsigned long four;
 };
 
-/* Try to trigger unhandled padding in a structure. */
-struct test_aligned {
-	u32 internal1;
-	u64 internal2;
-} __aligned(64);
-
+/* Trigger unhandled padding in a structure. */
 struct test_big_hole {
 	u8 one;
 	u8 two;
 	u8 three;
 	/* 61 byte padding hole here. */
-	struct test_aligned four;
+	u8 four __aligned(64);
 } __aligned(64);
 
 struct test_trailing_hole {


