Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DD159E1FB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355893AbiHWKsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355907AbiHWKpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4F56CF45;
        Tue, 23 Aug 2022 02:11:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C714260DB4;
        Tue, 23 Aug 2022 09:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8DBC433D7;
        Tue, 23 Aug 2022 09:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245884;
        bh=Sre9OUNT1C+sApeMd7ViCEj8XBfVPEfA34NRRnDMWGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aT+UaxF6VTs9YJqCsvpMlcFlbhepuDwTg9d6GHIiCyYZnwbK/zh6h6QgwxDls0Hdk
         pgCiy1/z+Wk9WEZ7z6cdmrphxXzECDqn+hJEWpFl34jdBIQt9iIEGf2qOD6N5QYAMW
         7/P6FZP9QCuK7d1wPVp82QSMvPsr9zSKKXo28uUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 221/287] tracing: Have filter accept "common_cpu" to be consistent
Date:   Tue, 23 Aug 2022 10:26:30 +0200
Message-Id: <20220823080108.418975031@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit b2380577d4fe1c0ef3fa50417f1e441c016e4cbe upstream.

Make filtering consistent with histograms. As "cpu" can be a field of an
event, allow for "common_cpu" to keep it from being confused with the
"cpu" field of the event.

Link: https://lkml.kernel.org/r/20220820134401.513062765@goodmis.org
Link: https://lore.kernel.org/all/20220820220920.e42fa32b70505b1904f0a0ad@kernel.org/

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 1e3bac71c5053 ("tracing/histogram: Rename "cpu" to "common_cpu"")
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -173,6 +173,7 @@ static int trace_define_generic_fields(v
 
 	__generic_field(int, CPU, FILTER_CPU);
 	__generic_field(int, cpu, FILTER_CPU);
+	__generic_field(int, common_cpu, FILTER_CPU);
 	__generic_field(char *, COMM, FILTER_COMM);
 	__generic_field(char *, comm, FILTER_COMM);
 


