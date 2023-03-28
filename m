Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C956CC55E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbjC1PNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbjC1PNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:13:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D204DDBF3
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C9F6B81D84
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED51FC4339B;
        Tue, 28 Mar 2023 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016222;
        bh=NBPZGQ942ws4fxaQ3ieQb0lyvmMVEn7kAkRYh8pGsSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIwXH/3n0KGo8PXyw6CxaVwJnJgZeOKZnAut3lkDF/GvFIB9/0rT8fWBJqqJnITLH
         TqBBUPuxgbJNPqsdkLTaANWtcfE945DGAyHo9bSFmtkvg3bpIDFe4jK0xeuvP94/PC
         SAQQM7gJwumeS/BbCu3sdkTdrIiVX8SEH3nW0Im0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Huckleberry <nhuck@google.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 110/146] fsverity: Remove WQ_UNBOUND from fsverity read workqueue
Date:   Tue, 28 Mar 2023 16:43:19 +0200
Message-Id: <20230328142607.266513929@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

commit f959325e6ac3f499450088b8d9c626d1177be160 upstream.

WQ_UNBOUND causes significant scheduler latency on ARM64/Android.  This
is problematic for latency sensitive workloads, like I/O
post-processing.

Removing WQ_UNBOUND gives a 96% reduction in fsverity workqueue related
scheduler latency and improves app cold startup times by ~30ms.
WQ_UNBOUND was also removed from the dm-verity workqueue for the same
reason [1].

This code was tested by running Android app startup benchmarks and
measuring how long the fsverity workqueue spent in the runnable state.

Before
Total workqueue scheduler latency: 553800us
After
Total workqueue scheduler latency: 18962us

[1]: https://lore.kernel.org/all/20230202012348.885402-1-nhuck@google.com/

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Fixes: 8a1d0f9cacc9 ("fs-verity: add data verification hooks for ->readpages()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230310193325.620493-1-nhuck@google.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/verify.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -279,15 +279,15 @@ EXPORT_SYMBOL_GPL(fsverity_enqueue_verif
 int __init fsverity_init_workqueue(void)
 {
 	/*
-	 * Use an unbound workqueue to allow bios to be verified in parallel
-	 * even when they happen to complete on the same CPU.  This sacrifices
-	 * locality, but it's worthwhile since hashing is CPU-intensive.
+	 * Use a high-priority workqueue to prioritize verification work, which
+	 * blocks reads from completing, over regular application tasks.
 	 *
-	 * Also use a high-priority workqueue to prioritize verification work,
-	 * which blocks reads from completing, over regular application tasks.
+	 * For performance reasons, don't use an unbound workqueue.  Using an
+	 * unbound workqueue for crypto operations causes excessive scheduler
+	 * latency on ARM64.
 	 */
 	fsverity_read_workqueue = alloc_workqueue("fsverity_read_queue",
-						  WQ_UNBOUND | WQ_HIGHPRI,
+						  WQ_HIGHPRI,
 						  num_online_cpus());
 	if (!fsverity_read_workqueue)
 		return -ENOMEM;


