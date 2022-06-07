Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6818540ED6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354173AbiFGSzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354667AbiFGSvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:51:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F01131F19;
        Tue,  7 Jun 2022 11:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5D81616B6;
        Tue,  7 Jun 2022 18:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D5AC36B04;
        Tue,  7 Jun 2022 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654625001;
        bh=lQx9gW3Yr7Nl5zsN5pDITSvemx1zVOWZTy2c3CMR3ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEo/AUAnMXALoq1vXXjIDJ1uKXhPLIp8bbZFOdhsvl5Qe9HBLRmF7CVFCiTtp39au
         0oqqi/SMqlYONmUMQ7Ii2u2ng6hPp9bgnTRGlD6GPWY4LLdLwJs+wYqNzMpV4DDcEA
         HrSU5p27d7s4e6PYCJV2DD5FEwZoTPP+lwsp+/Ox0oALFNgAZ7aVhc1bpX1nK4MG9Y
         SE7tLtoVCk3wOX36R9i730/2EwOTApqeZvnFhe+nlyr5+T8q2FxyLWhzZAhPi/xQ5s
         HI9Fxbr2uB5oMY3OHpUadIQJaEqPmHX8No75M9W8WvtyOFoSrV/gHybK+qDhPQzDZ9
         KXjETu5GKGZ5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/19] lkdtm/usercopy: Expand size of "out of frame" object
Date:   Tue,  7 Jun 2022 14:02:57 -0400
Message-Id: <20220607180317.482354-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180317.482354-1-sashal@kernel.org>
References: <20220607180317.482354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/misc/lkdtm_usercopy.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/lkdtm_usercopy.c b/drivers/misc/lkdtm_usercopy.c
index 1dd611423d8b..36438947244d 100644
--- a/drivers/misc/lkdtm_usercopy.c
+++ b/drivers/misc/lkdtm_usercopy.c
@@ -28,12 +28,12 @@ static const unsigned char test_text[] = "This is a test.\n";
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
@@ -41,7 +41,12 @@ static noinline unsigned char *do_usercopy_stack_callee(int value)
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
@@ -64,6 +69,12 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
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

