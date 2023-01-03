Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D741165BBF6
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbjACIRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbjACIQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AE1DFA5
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 512B2B80E4B
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E59EC433F0;
        Tue,  3 Jan 2023 08:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733797;
        bh=yutiAroojPVMXPTBVacQft2WfOCEUWXOc3rDaJ5VcuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uStH3fKRM04eJkCyXtO3lzTZCTeIbjH09X2wHGzHp120mrAgdToU6+DdXEpH+B6X1
         Owu6yuXq+iN3MaW4NKVj+EHEtPfzgaYumWxko7GQCSfHKDzEcMV56L7B+GnPSq/LN9
         x2uKAdcaOsQUfzgbvK8X3m5MhVVWSnXFa+6d5GH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 47/63] kernel: allow fork with TIF_NOTIFY_SIGNAL pending
Date:   Tue,  3 Jan 2023 09:14:17 +0100
Message-Id: <20230103081311.416060396@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
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

[ Upstream commit 66ae0d1e2d9fe6ec70e73fcfdcf4b390e271c1ac ]

fork() fails if signal_pending() is true, but there are two conditions
that can lead to that:

1) An actual signal is pending. We want fork to fail for that one, like
   we always have.

2) TIF_NOTIFY_SIGNAL is pending, because the task has pending task_work.
   We don't need to make it fail for that case.

Allow fork() to proceed if just task_work is pending, by changing the
signal_pending() check to task_sigpending().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1942,7 +1942,7 @@ static __latent_entropy struct task_stru
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	retval = -ERESTARTNOINTR;
-	if (signal_pending(current))
+	if (task_sigpending(current))
 		goto fork_out;
 
 	retval = -ENOMEM;


