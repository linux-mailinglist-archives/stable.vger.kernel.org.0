Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2A160A300
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiJXLt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiJXLr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:47:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BDF1A22C;
        Mon, 24 Oct 2022 04:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24DB2CE1343;
        Mon, 24 Oct 2022 11:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11739C433C1;
        Mon, 24 Oct 2022 11:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611652;
        bh=1IOQmUI6946jvhWqijchMtnbXd4TLovY9etrS+Rty8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zm/oux05W9eArkEkk9V83dEQC89t6QT5L8d3pnkmrmFigWHNSIwC28tQooinGFFxv
         Gju+fVOcFnpBDFByXUjxlNYmCjSIJBMUaIZ9oSa0CFhFyI+8Hkp4tar+v631tkCwV7
         QkuALV/mcirL4XiXOaTztqTCjKzsGHu237cAMx4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 060/159] ring-buffer: Check pending waiters when doing wake ups as well
Date:   Mon, 24 Oct 2022 13:30:14 +0200
Message-Id: <20221024112951.631538334@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit ec0bbc5ec5664dcee344f79373852117dc672c86 upstream.

The wake up waiters only checks the "wakeup_full" variable and not the
"full_waiters_pending". The full_waiters_pending is set when a waiter is
added to the wait queue. The wakeup_full is only set when an event is
triggered, and it clears the full_waiters_pending to avoid multiple calls
to irq_work_queue().

The irq_work callback really needs to check both wakeup_full as well as
full_waiters_pending such that this code can be used to wake up waiters
when a file is closed that represents the ring buffer and the waiters need
to be woken up.

Link: https://lkml.kernel.org/r/20220927231824.209460321@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 15693458c4bc0 ("tracing/ring-buffer: Move poll wake ups into ring buffer code")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -513,8 +513,9 @@ static void rb_wake_up_waiters(struct ir
 	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
 
 	wake_up_all(&rbwork->waiters);
-	if (rbwork->wakeup_full) {
+	if (rbwork->full_waiters_pending || rbwork->wakeup_full) {
 		rbwork->wakeup_full = false;
+		rbwork->full_waiters_pending = false;
 		wake_up_all(&rbwork->full_waiters);
 	}
 }


