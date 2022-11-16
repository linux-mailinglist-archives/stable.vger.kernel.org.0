Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0662B656
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 10:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiKPJWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 04:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiKPJWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 04:22:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C7427146;
        Wed, 16 Nov 2022 01:21:59 -0800 (PST)
Date:   Wed, 16 Nov 2022 09:21:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668590517;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YA4CPPTUVtYwpqhvtLMRcFwGP6fQVGdvDsF0bj73KSA=;
        b=VxmlUt0Rfc7jGSAI7OPLtXBB0F272IfyHu+aMj1kOvVlO84Fs6ubReh6wipUI8pjsWSOLk
        Ab+CPw8tiJJQLU30OYACyETBV4Ucpo1r5vpnZA1hqPImlOo/4tGMQ74MkF3EmAZx2/CYci
        pk/Hj1ztosTQQWfSv9uPp4x3/at5lFGZDc+osC0X6MT7/jDtvL5+U5rzvv6zFpl4B7BRrq
        TCly7rIImcCKaq7kmWxxzbgGwmQeNnVoy7tQSUmUQJ9RXF+6YDEpk8+892YszFBFH4BkGn
        hn1GOR6mD03KuMVILEsguEj0imM/xAtGuR8SJQe9puIWPCyGhpmbYa3oLECtCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668590517;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YA4CPPTUVtYwpqhvtLMRcFwGP6fQVGdvDsF0bj73KSA=;
        b=mF5Ennni/19N9fRtmA1MwQPUMpq6OZaTAFlrt9sC3R/jXGLd7sWCcVg4L2z/HbulXszbWe
        Ofoft4PSuldlt8CQ==
From:   "tip-bot2 for Adrian Hunter" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel/pt: Fix sampling using single range output
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221112151508.13768-1-adrian.hunter@intel.com>
References: <20221112151508.13768-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Message-ID: <166859051658.4906.7352282169801138446.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     ce0d998be9274dd3a3d971cbeaa6fe28fd2c3062
Gitweb:        https://git.kernel.org/tip/ce0d998be9274dd3a3d971cbeaa6fe28fd2c3062
Author:        Adrian Hunter <adrian.hunter@intel.com>
AuthorDate:    Sat, 12 Nov 2022 17:15:08 +02:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 16 Nov 2022 10:12:59 +01:00

perf/x86/intel/pt: Fix sampling using single range output

Deal with errata TGL052, ADL037 and RPL017 "Trace May Contain Incorrect
Data When Configured With Single Range Output Larger Than 4KB" by
disabling single range output whenever larger than 4KB.

Fixes: 670638477aed ("perf/x86/intel/pt: Opportunistically use single range output mode")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221112151508.13768-1-adrian.hunter@intel.com
---
 arch/x86/events/intel/pt.c |  9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 82ef87e..42a5579 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1263,6 +1263,15 @@ static int pt_buffer_try_single(struct pt_buffer *buf, int nr_pages)
 	if (1 << order != nr_pages)
 		goto out;
 
+	/*
+	 * Some processors cannot always support single range for more than
+	 * 4KB - refer errata TGL052, ADL037 and RPL017. Future processors might
+	 * also be affected, so for now rather than trying to keep track of
+	 * which ones, just disable it for all.
+	 */
+	if (nr_pages > 1)
+		goto out;
+
 	buf->single = true;
 	buf->nr_pages = nr_pages;
 	ret = 0;
