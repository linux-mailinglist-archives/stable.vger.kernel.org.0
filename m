Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C775D68966F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjBCK0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjBCKY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:24:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80199D599
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:24:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC4CB61ED1
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6372C433AA;
        Fri,  3 Feb 2023 10:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419867;
        bh=dsy3YWhkKzp2txKhA8z4hxCJ1vOdg+ndBt0MQUuhYXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On0LpP9kQ783vxxrSPi1R7pwVUF/ROEVywSTfNNNN/n0djI9runNvxqXc1u1gwwu2
         OwDmu+mrawGW9wkPiHAL5EbQSrGj02NUq3T35+Pik+t/db9cIJd9/ehCcFtU/aWL6K
         sskk9Y4L/FXWmmIPkRoCWtEzxmhdMz9ZYQYLD/BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.15 17/20] selftests/vm: remove ARRAY_SIZE define from individual tests
Date:   Fri,  3 Feb 2023 11:13:44 +0100
Message-Id: <20230203101008.714697109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit e89908201e2509354c40158b517945bf3d645812 upstream.

ARRAY_SIZE is defined in several selftests. Remove definitions from
individual test files and include header file for the define instead.
ARRAY_SIZE define is added in a separate patch to prepare for this
change.

Remove ARRAY_SIZE from vm tests and pickup the one defined in
kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Kyle Huey <me@kylehuey.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/mremap_test.c    |    1 -
 tools/testing/selftests/vm/pkey-helpers.h   |    3 ++-
 tools/testing/selftests/vm/va_128TBswitch.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -22,7 +22,6 @@
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
 
 struct config {
--- a/tools/testing/selftests/vm/pkey-helpers.h
+++ b/tools/testing/selftests/vm/pkey-helpers.h
@@ -13,6 +13,8 @@
 #include <ucontext.h>
 #include <sys/mman.h>
 
+#include "../kselftest.h"
+
 /* Define some kernel-like types */
 #define  u8 __u8
 #define u16 __u16
@@ -175,7 +177,6 @@ static inline void __pkey_write_allow(in
 	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
 }
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 #define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
 #define ALIGN_DOWN(x, align_to) ((x) & ~((align_to)-1))
 #define ALIGN_PTR_UP(p, ptr_align_to)	\
--- a/tools/testing/selftests/vm/va_128TBswitch.c
+++ b/tools/testing/selftests/vm/va_128TBswitch.c
@@ -9,7 +9,7 @@
 #include <sys/mman.h>
 #include <string.h>
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#include "../kselftest.h"
 
 #ifdef __powerpc64__
 #define PAGE_SIZE	(64 << 10)


