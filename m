Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66D4F2575
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiDEHty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiDEHrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4602A9682B;
        Tue,  5 Apr 2022 00:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E55CE616D9;
        Tue,  5 Apr 2022 07:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001DEC340EE;
        Tue,  5 Apr 2022 07:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144565;
        bh=U6NPccItde/lV+Aupb+80yWZKd2ruP1llhPD9xnH5U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUcj1D8J2CEhdPctbRSp+LCsOQYJg7ncWsLEe3C4Q7uQ/YpTc1zWzbxkaDLJeqDON
         G5VOv+b5RrVUj3Y2eIdiyjfjOCVpwVeeQ4PWUcARZnP5fM2Ixsw+JQVQhkUE7RJ/KV
         Fw+hXTlgTVJJRt3oUMdKj4A7JHdNjH2yZp0i9+HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.17 0089/1126] riscv: Increase stack size under KASAN
Date:   Tue,  5 Apr 2022 09:13:56 +0200
Message-Id: <20220405070410.181294599@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
 


