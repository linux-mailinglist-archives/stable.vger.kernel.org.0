Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A9B6B42CE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjCJOHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjCJOG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:06:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65C110F859
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B668EB822C3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B22C433EF;
        Fri, 10 Mar 2023 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457183;
        bh=NvTI4qf5sKzalATCqRQ8nzW4CH2chdRl2A4V7MhqBQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McNVAsxL/Hbr2gX9ZBNHOww+M0YZg5U2V0KEcDzdispX84iGW6E1gRkdUi8Z1GCB+
         Qd+l1yurZ+Qh0uxChV0HnQJZtRzBhGPStULeMywN9ZSD+G9bWezFc7Xs6GuUYSJsSd
         LqE6L4nPbG2vaXWN+kKHxgUDw0NWspfCYAi5YW3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/200] x86: um: vdso: Add %rcx and %r11 to the syscall clobber list
Date:   Fri, 10 Mar 2023 14:37:35 +0100
Message-Id: <20230310133718.575836293@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

[ Upstream commit 5541992e512de8c9133110809f767bd1b54ee10d ]

The 'syscall' instruction clobbers '%rcx' and '%r11', but they are not
listed in the inline Assembly that performs the syscall instruction.

No real bug is found. It wasn't buggy by luck because '%rcx' and '%r11'
are caller-saved registers, and not used in the functions, and the
functions are never inlined.

Add them to the clobber list for code correctness.

Fixes: f1c2bb8b9964ed31de988910f8b1cfb586d30091 ("um: implement a x86_64 vDSO")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/vdso/um_vdso.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/um/vdso/um_vdso.c b/arch/x86/um/vdso/um_vdso.c
index 2112b8d146688..ff0f3b4b6c45e 100644
--- a/arch/x86/um/vdso/um_vdso.c
+++ b/arch/x86/um/vdso/um_vdso.c
@@ -17,8 +17,10 @@ int __vdso_clock_gettime(clockid_t clock, struct __kernel_old_timespec *ts)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_clock_gettime), "D" (clock), "S" (ts)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
@@ -29,8 +31,10 @@ int __vdso_gettimeofday(struct __kernel_old_timeval *tv, struct timezone *tz)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_gettimeofday), "D" (tv), "S" (tz)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
-- 
2.39.2



