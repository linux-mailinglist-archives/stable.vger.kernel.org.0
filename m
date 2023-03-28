Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB0C6CC34D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbjC1Ow7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjC1Own (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159FEE042
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98896B81D73
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00701C433EF;
        Tue, 28 Mar 2023 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015157;
        bh=gdEm5J4Mtqm5LqsYok6JRVjOpH96rzPv4a0zcCmHN1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKRioAgMwjuQ/381kiTaHlOfTZxxtUK+tTiyxovl1Uz7XTKFdyU6LgOe5yJoa+MXX
         0QXqbeWF4bF4J2YtYd4LQ6XUp+06GUMuiJaLI/MtFDXZrsNI8QgmizBZ0QJZGAD4/H
         j5cqKTzsaFTUgTVs7f8dA5bPBHPvOkR154nrizFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Huckleberry <nhuck@google.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6.2 186/240] fsverity: Remove WQ_UNBOUND from fsverity read workqueue
Date:   Tue, 28 Mar 2023 16:42:29 +0200
Message-Id: <20230328142627.388577531@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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
@@ -269,15 +269,15 @@ EXPORT_SYMBOL_GPL(fsverity_enqueue_verif
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


