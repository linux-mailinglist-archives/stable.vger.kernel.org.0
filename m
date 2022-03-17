Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951FA4DC6D0
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiCQMz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiCQMwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256BB1F1635;
        Thu, 17 Mar 2022 05:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAF67B81DA1;
        Thu, 17 Mar 2022 12:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2823EC340EF;
        Thu, 17 Mar 2022 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521409;
        bh=Aam8fO933+rwoFhOIFIjI5gVcPRNyjusS5F4VJONDuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzmzoWi1m/IHsPMXdj0PoIw8lnO7K6Xc/Fi/vB4tX/u1rzUIw9l0IswigKk6TStMP
         5ipX7ZQadCreya+kH1KGq0KjCe70xXwq0FmYSdvjFektIWVOq6emkWuRZWRKF30H1t
         vZ0EFG6EduAQ/r87Pbt63djV07QrvsNo7JtCG+Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.10 22/23] io_uring: return back safer resurrect
Date:   Thu, 17 Mar 2022 13:46:03 +0100
Message-Id: <20220317124526.600389707@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
References: <20220317124525.955110315@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit f70865db5ff35f5ed0c7e9ef63e7cca3d4947f04 upstream.

Revert of revert of "io_uring: wait potential ->release() on resurrect",
which adds a helper for resurrect not racing completion reinit, as was
removed because of a strange bug with no clear root or link to the
patch.

Was improved, instead of rcu_synchronize(), just wait_for_completion()
because we're at 0 refs and it will happen very shortly. Specifically
use non-interruptible version to ignore all pending signals that may
have ended prior interruptible wait.

This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1009,6 +1009,18 @@ static inline bool __io_match_files(stru
 		req->work.identity->files == files;
 }
 
+static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
+{
+	bool got = percpu_ref_tryget(ref);
+
+	/* already at zero, wait for ->release() */
+	if (!got)
+		wait_for_completion(compl);
+	percpu_ref_resurrect(ref);
+	if (got)
+		percpu_ref_put(ref);
+}
+
 static bool io_match_task(struct io_kiocb *head,
 			  struct task_struct *task,
 			  struct files_struct *files)
@@ -9757,12 +9769,11 @@ static int __io_uring_register(struct io
 			if (ret < 0)
 				break;
 		} while (1);
-
 		mutex_lock(&ctx->uring_lock);
 
 		if (ret) {
-			percpu_ref_resurrect(&ctx->refs);
-			goto out_quiesce;
+			io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
+			return ret;
 		}
 	}
 
@@ -9855,7 +9866,6 @@ out:
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-out_quiesce:
 		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;


