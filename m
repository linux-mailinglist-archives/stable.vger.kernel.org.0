Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3844A4FC0E2
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347861AbiDKPhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345323AbiDKPhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:37:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CADA38186
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 235AFB816C7
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A18C385A3;
        Mon, 11 Apr 2022 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649691322;
        bh=DepPSpJ2IBhrBDaaItkG+gHvIBMyADLlMk8TOnRZ7OM=;
        h=Subject:To:Cc:From:Date:From;
        b=Sz2gz5bTCPvRYbdPtHcYVCSKbK/gcQZf0VR8Ux7oUBxIVjE1uX3a5VFt7UT50Rfog
         5RaGa1HRYBfqLNKAWTvFgDgV227WMtsgzT1Zhbr3lpqNtU13SSxt0GjXGW2F1jH+dG
         1AOrplNZooVePOJ/kudwuQxl/eX1gA/jIeZPAR7k=
Subject: FAILED: patch "[PATCH] random: check for signal_pending() outside of need_resched()" failed to apply to 5.10-stable tree
To:     jannh@google.com, Jason@zx2c4.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 17:35:15 +0200
Message-ID: <1649691315139194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1448769c9cdb69ad65287f4f7ab58bc5f2f5d7ba Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Tue, 5 Apr 2022 18:39:31 +0200
Subject: [PATCH] random: check for signal_pending() outside of need_resched()
 check

signal_pending() checks TIF_NOTIFY_SIGNAL and TIF_SIGPENDING, which
signal that the task should bail out of the syscall when possible. This
is a separate concept from need_resched(), which checks
TIF_NEED_RESCHED, signaling that the task should preempt.

In particular, with the current code, the signal_pending() bailout
probably won't work reliably.

Change this to look like other functions that read lots of data, such as
read_zero().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 47f01b1482a9..394cbd814a0b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -549,13 +549,13 @@ static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
 	}
 
 	do {
-		if (large_request && need_resched()) {
+		if (large_request) {
 			if (signal_pending(current)) {
 				if (!ret)
 					ret = -ERESTARTSYS;
 				break;
 			}
-			schedule();
+			cond_resched();
 		}
 
 		chacha20_block(chacha_state, output);

