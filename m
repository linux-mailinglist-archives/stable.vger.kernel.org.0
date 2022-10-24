Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D4E60B80A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiJXTkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiJXTkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220311D1021;
        Mon, 24 Oct 2022 11:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D9A7B811A9;
        Mon, 24 Oct 2022 11:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1381C433B5;
        Mon, 24 Oct 2022 11:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612112;
        bh=exJ6/ycf2cPgXPDrwu+frN0ZqvWYWR4ZkIMOmn0PI5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSNtaVm28anVXL2mizqvNFQXQqSsnv0DyqFX5LsqulmvS0ZCfj1kAaeu70M2TdD9U
         tSThzEpRgk9k15698rLOuLjuoab6/Z/ThUlpBopvXJbCUV/3Zj9pMEwMDnkOP4VW4h
         eX+oqYYfoaLD0JVW9UsJmM1UH3OO1GjDvu7ZoWSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 075/210] ring-buffer: Check pending waiters when doing wake ups as well
Date:   Mon, 24 Oct 2022 13:29:52 +0200
Message-Id: <20221024112959.497465537@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -512,8 +512,9 @@ static void rb_wake_up_waiters(struct ir
 	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
 
 	wake_up_all(&rbwork->waiters);
-	if (rbwork->wakeup_full) {
+	if (rbwork->full_waiters_pending || rbwork->wakeup_full) {
 		rbwork->wakeup_full = false;
+		rbwork->full_waiters_pending = false;
 		wake_up_all(&rbwork->full_waiters);
 	}
 }


