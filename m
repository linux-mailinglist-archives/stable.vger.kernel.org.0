Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5E86677B6
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbjALOrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbjALOqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:46:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E019A5F929
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77ECC62032
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87039C433EF;
        Thu, 12 Jan 2023 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534085;
        bh=EU6StfKn7RbfARBEbyKypkYQxXj7eoDXbNsNOEjcZvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwg5YvuxfuXjKKkRwW93vR9ZeiPyE6bpQz8KrtgbWx2l8SfqrHK353SN6w8nIQd/y
         dpt9m+V+NvPQyu++aixsf9Vsp5I/qqV3tnnOAO48Sb4NObaApzfFr6uMFxE2mITE1C
         61ILCO7/SRKneNWXUiWjv+7BqlzTtqAS2Y/Mkvac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Hui Tang <tanghui20@huawei.com>
Subject: [PATCH 5.10 690/783] ARM: renumber bits related to _TIF_WORK_MASK
Date:   Thu, 12 Jan 2023 14:56:46 +0100
Message-Id: <20230112135556.295164361@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 191f8453fc99a537ea78b727acea739782378b0d upstream.

We want to ensure that the mask related to calling do_work_pending()
is within the first 16 bits. Move bits unrelated to that outside of
that range, to avoid spuriously calling do_work_pending() when we don't
need to.

Cc: stable@vger.kernel.org
Fixes: 32d59773da38 ("arm: add support for TIF_NOTIFY_SIGNAL")
Reported-and-tested-by: Hui Tang <tanghui20@huawei.com>
Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Link: https://lore.kernel.org/lkml/7ecb8f3c-2aeb-a905-0d4a-aa768b9649b5@huawei.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/thread_info.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -133,15 +133,16 @@ extern int vfp_restore_user_hwstate(stru
 #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_UPROBE		3	/* breakpointed or singlestepping */
-#define TIF_SYSCALL_TRACE	4	/* syscall trace active */
-#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
-#define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
-#define TIF_SECCOMP		7	/* seccomp syscall filtering active */
-#define TIF_NOTIFY_SIGNAL	8	/* signal notifications exist */
+#define TIF_NOTIFY_SIGNAL	4	/* signal notifications exist */
 
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
-#define TIF_RESTORE_SIGMASK	20
+#define TIF_RESTORE_SIGMASK	19
+#define TIF_SYSCALL_TRACE	20	/* syscall trace active */
+#define TIF_SYSCALL_AUDIT	21	/* syscall auditing active */
+#define TIF_SYSCALL_TRACEPOINT	22	/* syscall tracepoint instrumentation */
+#define TIF_SECCOMP		23	/* seccomp syscall filtering active */
+
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)


