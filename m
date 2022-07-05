Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3760E566B66
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiGEMGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiGEMFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447551836D;
        Tue,  5 Jul 2022 05:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D623961806;
        Tue,  5 Jul 2022 12:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E383CC341C7;
        Tue,  5 Jul 2022 12:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022698;
        bh=DB8eicDF/6K1J0x84ZrkKaGwNZtyKlbufNAU/VbW7F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTkmKPHG0kqwBhrucoB94FpNr9r8Gd8TBgNE7Kcqxt92fNYsjj309DnPE3Mzn3/2Q
         JfQF1k/O46N/p4u8/y1jTKb+tQViehjonO0LBSIdb4njOfPZjlsPNTJY+WrD6EKo+O
         zEq+7Rs1hFc3LKxNsPejJ27akMWYKrYleN1LQ1Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 37/58] selftests/rseq: Remove useless assignment to cpu variable
Date:   Tue,  5 Jul 2022 13:58:13 +0200
Message-Id: <20220705115611.337634489@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 930378d056eac2c96407b02aafe4938d0ac9cc37 upstream.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-4-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/param_test.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/rseq/param_test.c
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -366,9 +366,7 @@ void *test_percpu_spinlock_thread(void *
 		abort();
 	reps = thread_data->reps;
 	for (i = 0; i < reps; i++) {
-		int cpu = rseq_cpu_start();
-
-		cpu = rseq_this_cpu_lock(&data->lock);
+		int cpu = rseq_this_cpu_lock(&data->lock);
 		data->c[cpu].count++;
 		rseq_percpu_unlock(&data->lock, cpu);
 #ifndef BENCHMARK


