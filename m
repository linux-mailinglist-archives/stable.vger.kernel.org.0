Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE983566BFC
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiGEMK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbiGEMI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D15A15FFB;
        Tue,  5 Jul 2022 05:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C845FB817CE;
        Tue,  5 Jul 2022 12:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17586C341C7;
        Tue,  5 Jul 2022 12:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022935;
        bh=V878LdBN19s8tRJg3JLUYQbVPB/+HWJ83r+Ig4+/bzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZX39cpaVbNdMjEVYNrizkHyQZACWnw3eRLovNPslWZ2TjEUP/2j6Q/Eo1bnJaQdn+
         gRALWUBJIWUmwqPM9SVeooUzSapreUBQY+wQvGiFpaDnXP+WzssU7uakSs8X3sop9C
         yZHeD2bFoinOIo8Sjl3A7eloddXpKA0Oq+z9Nf6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 62/84] selftests/rseq: Remove useless assignment to cpu variable
Date:   Tue,  5 Jul 2022 13:58:25 +0200
Message-Id: <20220705115617.132290829@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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
@@ -368,9 +368,7 @@ void *test_percpu_spinlock_thread(void *
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


