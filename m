Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E7558428
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiFWRkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiFWRiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:38:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC49718E1F;
        Thu, 23 Jun 2022 10:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDB861D02;
        Thu, 23 Jun 2022 17:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2B9C3411B;
        Thu, 23 Jun 2022 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004085;
        bh=OpoznZMK1Ok1ZJg+f5Ff1jh+Gv+HjqOFJILFgEo6XZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtA3/p7xFdJPgU/d4uBMPcuD6bsc9u8djBJ/zZgDd3pHNcbiXnhpY9pw/DfX89dfI
         VF83A6OYGBu6Y+UpnTKKKoBEdDyG2hY2JaEHDH9YApY7JQZy8G180jM/1QOqRd18et
         1DDRHAGqnj3QRpIYMLaZmWjLRvs9yZ9P3oNwteog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 142/237] random: check for signal_pending() outside of need_resched() check
Date:   Thu, 23 Jun 2022 18:42:56 +0200
Message-Id: <20220623164347.240163376@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
@@ -549,13 +549,13 @@ static ssize_t get_random_bytes_user(voi
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


