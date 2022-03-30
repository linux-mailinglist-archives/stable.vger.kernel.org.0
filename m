Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D984A4EC07E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344041AbiC3Lvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344105AbiC3Lu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4272706F7;
        Wed, 30 Mar 2022 04:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E09A7615F5;
        Wed, 30 Mar 2022 11:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA985C3410F;
        Wed, 30 Mar 2022 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640872;
        bh=B+LL6HqRHaXg/j5A4/f7HpsysJBncMEphF9/Mdw/N7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KA9MBMx9ycrp+J1LNOnriRa1Ftta4cFb5mjmXy/vmUDqEEIzvXkwc1Cyg/M2HNEoX
         8OCVONV4yBqBaXqOnIU2oTa3FYYvzDDSPxZ6pdNOzdWklre4MtnBxFpVX80XKy3OWN
         3pxh6r3zMPN/2cRhaTek2qmv/6FyzgGlxBA6CcURkFXXBzrd9ju4H0jbRA31CdU4qP
         oF+UbjqKruZYTJ2ATNZEJdcR3XPM9Vs697oq13Cfc3JzrjHWJk64qOq2tkdNfrVVTw
         K15mnwOdhtn8NS3U2AoFBCnwilsazTm/j8pj748KmDr5VK8KQk6f8jUq+5kXiylIih
         sdMGRY3ANkHAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 42/66] lib/test_lockup: fix kernel pointer check for separate address spaces
Date:   Wed, 30 Mar 2022 07:46:21 -0400
Message-Id: <20220330114646.1669334-42-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5a06fcb15b43d1f7bf740c672950122331cb5655 ]

test_kernel_ptr() uses access_ok() to figure out if a given address
points to user space instead of kernel space. However on architectures
that set CONFIG_ALTERNATE_USER_ADDRESS_SPACE, a pointer can be valid
for both, and the check always fails because access_ok() returns true.

Make the check for user space pointers conditional on the type of
address space layout.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_lockup.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/test_lockup.c b/lib/test_lockup.c
index 6a0f329a794a..c3fd87d6c2dd 100644
--- a/lib/test_lockup.c
+++ b/lib/test_lockup.c
@@ -417,9 +417,14 @@ static bool test_kernel_ptr(unsigned long addr, int size)
 		return false;
 
 	/* should be at least readable kernel address */
-	if (access_ok((void __user *)ptr, 1) ||
-	    access_ok((void __user *)ptr + size - 1, 1) ||
-	    get_kernel_nofault(buf, ptr) ||
+	if (!IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) &&
+	    (access_ok((void __user *)ptr, 1) ||
+	     access_ok((void __user *)ptr + size - 1, 1))) {
+		pr_err("user space ptr invalid in kernel: %#lx\n", addr);
+		return true;
+	}
+
+	if (get_kernel_nofault(buf, ptr) ||
 	    get_kernel_nofault(buf, ptr + size - 1)) {
 		pr_err("invalid kernel ptr: %#lx\n", addr);
 		return true;
-- 
2.34.1

