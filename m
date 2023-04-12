Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3146DEED1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjDLIpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjDLIoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000F56E8B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AD6C62AE9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4220BC4339C;
        Wed, 12 Apr 2023 08:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289066;
        bh=PHG4L2sYEwAW9G4KcXZyk02SCWpC/6epzTDNMCHUL80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gay8KsdKFxFzRaNYiltrysokG6HYj6xjNZOGd9AvuZtiYjNhiOZm8m/i1UI2DsJyL
         HpUh2B7xqSBxhYw2h6ozEGNktm11wypjmX5fVRSu0QoeN79Q5m5Wr/r9Z04B5xuhAt
         lrCNpOi6wzgbv6ygbzg7EzPFMcMxJDXpZAxU45Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 124/164] tracing/timerlat: Notify new max thread latency
Date:   Wed, 12 Apr 2023 10:34:06 +0200
Message-Id: <20230412082841.868871290@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit b9f451a9029a16eb7913ace09b92493d00f2e564 upstream.

timerlat is not reporting a new tracing_max_latency for the thread
latency. The reason is that it is not calling notify_new_max_latency()
function after the new thread latency is sampled.

Call notify_new_max_latency() after computing the thread latency.

Link: https://lkml.kernel.org/r/16e18d61d69073d0192ace07bf61e405cca96e9c.1680104184.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Fixes: dae181349f1e ("tracing/osnoise: Support a list of trace_array *tr")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1681,6 +1681,8 @@ static int timerlat_main(void *data)
 
 		trace_timerlat_sample(&s);
 
+		notify_new_max_latency(diff);
+
 		timerlat_dump_stack(time_to_us(diff));
 
 		tlat->tracing_thread = false;


