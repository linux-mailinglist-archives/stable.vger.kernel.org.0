Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475B84F3046
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiDEKhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbiDEJd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4785714B;
        Tue,  5 Apr 2022 02:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 620E9B81C6F;
        Tue,  5 Apr 2022 09:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C66C385A2;
        Tue,  5 Apr 2022 09:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150545;
        bh=U6NPccItde/lV+Aupb+80yWZKd2ruP1llhPD9xnH5U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOKbBuQv1CjsJb2q0ZDUeXdNrWCn7UV7h2w4YJpWzKIpn6Gs1sEoD9GcrgYa70XHX
         GxD4H4kAY00JKBTyjnj0bPM4GOtAVNU1Pw8hhZ4Dmfgb5DKI0fvaDSV0OPYwf1/54n
         F2vuQuxkLbCPP2LnuS2qWmz147uPcve+PFC8hNMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 095/913] riscv: Increase stack size under KASAN
Date:   Tue,  5 Apr 2022 09:19:17 +0200
Message-Id: <20220405070342.676238143@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dmitry Vyukov <dvyukov@google.com>

commit b81d591386c3a50b96dddcf663628ea0df0bf2b3 upstream.

KASAN requires more stack space because of compiler instrumentation.
Increase stack size as other arches do.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com
Fixes: 8ad8b72721d0 ("riscv: Add KASAN support")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/thread_info.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -11,11 +11,17 @@
 #include <asm/page.h>
 #include <linux/const.h>
 
+#ifdef CONFIG_KASAN
+#define KASAN_STACK_ORDER 1
+#else
+#define KASAN_STACK_ORDER 0
+#endif
+
 /* thread information allocation */
 #ifdef CONFIG_64BIT
-#define THREAD_SIZE_ORDER	(2)
+#define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
 #else
-#define THREAD_SIZE_ORDER	(1)
+#define THREAD_SIZE_ORDER	(1 + KASAN_STACK_ORDER)
 #endif
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 


