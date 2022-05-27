Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F5C5360FC
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349559AbiE0L5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353316AbiE0L4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0C11F1;
        Fri, 27 May 2022 04:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C0B861D9F;
        Fri, 27 May 2022 11:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29497C385A9;
        Fri, 27 May 2022 11:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652270;
        bh=wCIxM11oAIZ58tWjDjX3rKJf4O9UkbW0mU0KOD/Q4VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDmwxYSsKpIDzDuUrzjPFV+3Dnb7UnJfkkXfKN2crrGNjC9hmlrjDzHmvsrsqTgTf
         J7cyBNxvPDgvTpbxmOiroyOJvZMsmGuqcWkBAx2adl2SRBHTd0BHbZm4/EQkwGhyo3
         Qhew18dWGjY4n4o73AlSRwghOGnS6cUWYI6O4sVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 115/163] random: check for signal_pending() outside of need_resched() check
Date:   Fri, 27 May 2022 10:49:55 +0200
Message-Id: <20220527084844.111085213@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 1448769c9cdb69ad65287f4f7ab58bc5f2f5d7ba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -551,13 +551,13 @@ static ssize_t get_random_bytes_user(voi
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


