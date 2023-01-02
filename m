Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3965B0FC
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjABL3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbjABL3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB076566
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8652760F59
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B280C433D2;
        Mon,  2 Jan 2023 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658912;
        bh=QtDZwUD3WY+gBj8kJWuA4ReBZW/eE2aMsMuocdidAEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LucLI+omxhn7+h3u9HvWd4rgoFlj0pXpe6mnWMkiHG7KD4syCVVR2Jm5ULjiekIUb
         X/qolAgWch1crZKJ4VM4+YnQkj202wScH4mSJie9QLVvsdPGqSvbeYyOFQxaG3vu5h
         6nsIMxayjTABdsBqUra2qYsUddZbcUvbPx32Fh9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 6.0 47/74] futex: Fix futex_waitv() hrtimer debug object leak on kcalloc error
Date:   Mon,  2 Jan 2023 12:22:20 +0100
Message-Id: <20230102110554.097673578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 94cd8fa09f5f1ebdd4e90964b08b7f2cc4b36c43 upstream.

In a scenario where kcalloc() fails to allocate memory, the futex_waitv
system call immediately returns -ENOMEM without invoking
destroy_hrtimer_on_stack(). When CONFIG_DEBUG_OBJECTS_TIMERS=y, this
results in leaking a timer debug object.

Fixes: bf69bad38cf6 ("futex: Implement sys_futex_waitv()")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org # v5.16+
Link: https://lore.kernel.org/r/20221214222008.200393-1-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/syscalls.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -286,19 +286,22 @@ SYSCALL_DEFINE5(futex_waitv, struct fute
 	}
 
 	futexv = kcalloc(nr_futexes, sizeof(*futexv), GFP_KERNEL);
-	if (!futexv)
-		return -ENOMEM;
+	if (!futexv) {
+		ret = -ENOMEM;
+		goto destroy_timer;
+	}
 
 	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
+	kfree(futexv);
+
+destroy_timer:
 	if (timeout) {
 		hrtimer_cancel(&to.timer);
 		destroy_hrtimer_on_stack(&to.timer);
 	}
-
-	kfree(futexv);
 	return ret;
 }
 


