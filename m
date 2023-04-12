Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E9B6DEFC6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjDLIxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjDLIxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B66EA251
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29A4E631C8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9ECC433EF;
        Wed, 12 Apr 2023 08:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289577;
        bh=OpCqSmB2KGNKYp4UT7PsVELkb4AQtCutdujDYdVQPBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYSc98XgS6/sP/ZPtb+tr9RtAX+7V3ViONq3oHfJaoowod3ya2UDLf204EuPL5czX
         Cq1pPfD1HaOn7r6G64mFZ6tH9T1iokYhbjOHan5RnsLf+B5GVtm1Jf+OYpeTFMh9aj
         RSBNrpMwl4OgBPuAV53+h+V5/6JYuUhV4wWvLs1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 123/173] tracing/osnoise: Fix notify new tracing_max_latency
Date:   Wed, 12 Apr 2023 10:34:09 +0200
Message-Id: <20230412082843.109095719@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit d3cba7f02cd82118c32651c73374d8a5a459d9a6 upstream.

osnoise/timerlat tracers are reporting new max latency on instances
where the tracing is off, creating inconsistencies between the max
reported values in the trace and in the tracing_max_latency. Thus
only report new tracing_max_latency on active tracing instances.

Link: https://lkml.kernel.org/r/ecd109fde4a0c24ab0f00ba1e9a144ac19a91322.1680104184.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Fixes: dae181349f1e ("tracing/osnoise: Support a list of trace_array *tr")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1296,7 +1296,7 @@ static void notify_new_max_latency(u64 l
 	rcu_read_lock();
 	list_for_each_entry_rcu(inst, &osnoise_instances, list) {
 		tr = inst->tr;
-		if (tr->max_latency < latency) {
+		if (tracer_tracing_is_on(tr) && tr->max_latency < latency) {
 			tr->max_latency = latency;
 			latency_fsnotify(tr);
 		}


