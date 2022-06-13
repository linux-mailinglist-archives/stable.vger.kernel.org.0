Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C175490FD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359040AbiFMNM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359479AbiFMNJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0B43A18D;
        Mon, 13 Jun 2022 04:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7182B60F16;
        Mon, 13 Jun 2022 11:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC6EC34114;
        Mon, 13 Jun 2022 11:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119253;
        bh=6nfGQcmOO+nzmnVXs7EuA6e3s87z59d7FQhJE3qTKds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pBAx25Z7mMg0QML+aNVgqy9PknqGvQcBf9bxcBMm2PnAHy2MjaDgMtGDXWtYxssh
         8lcudWwxWUiZCp9/PkqQYV6NRtP9qk5M8V9h3aXTT1RJfpF44A1vluc3ZgGJVi5lTW
         vkUPneb7/5kcYHucRjAwUaPG8gFEPt/FEfMFMYf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/247] lkdtm/usercopy: Expand size of "out of frame" object
Date:   Mon, 13 Jun 2022 12:11:10 +0200
Message-Id: <20220613094928.054005217@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit f387e86d3a74407bdd9c5815820ac9d060962840 ]

To be sufficiently out of range for the usercopy test to see the lifetime
mismatch, expand the size of the "bad" buffer, which will let it be
beyond current_stack_pointer regardless of stack growth direction.
Paired with the recent addition of stack depth checking under
CONFIG_HARDENED_USERCOPY=y, this will correctly start tripping again.

Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/lkml/762faf1b-0443-5ddf-4430-44a20cf2ec4d@collabora.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/usercopy.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/lkdtm/usercopy.c b/drivers/misc/lkdtm/usercopy.c
index 9161ce7ed47a..3fead5efe523 100644
--- a/drivers/misc/lkdtm/usercopy.c
+++ b/drivers/misc/lkdtm/usercopy.c
@@ -30,12 +30,12 @@ static const unsigned char test_text[] = "This is a test.\n";
  */
 static noinline unsigned char *trick_compiler(unsigned char *stack)
 {
-	return stack + 0;
+	return stack + unconst;
 }
 
 static noinline unsigned char *do_usercopy_stack_callee(int value)
 {
-	unsigned char buf[32];
+	unsigned char buf[128];
 	int i;
 
 	/* Exercise stack to avoid everything living in registers. */
@@ -43,7 +43,12 @@ static noinline unsigned char *do_usercopy_stack_callee(int value)
 		buf[i] = value & 0xff;
 	}
 
-	return trick_compiler(buf);
+	/*
+	 * Put the target buffer in the middle of stack allocation
+	 * so that we don't step on future stack users regardless
+	 * of stack growth direction.
+	 */
+	return trick_compiler(&buf[(128/2)-32]);
 }
 
 static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
@@ -66,6 +71,12 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 		bad_stack -= sizeof(unsigned long);
 	}
 
+#ifdef ARCH_HAS_CURRENT_STACK_POINTER
+	pr_info("stack     : %px\n", (void *)current_stack_pointer);
+#endif
+	pr_info("good_stack: %px-%px\n", good_stack, good_stack + sizeof(good_stack));
+	pr_info("bad_stack : %px-%px\n", bad_stack, bad_stack + sizeof(good_stack));
+
 	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
 			    PROT_READ | PROT_WRITE | PROT_EXEC,
 			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
-- 
2.35.1



