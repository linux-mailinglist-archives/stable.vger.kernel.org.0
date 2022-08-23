Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341C659DCEC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359334AbiHWMHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359739AbiHWMGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:06:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243EBDEB67;
        Tue, 23 Aug 2022 02:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA9BB81C98;
        Tue, 23 Aug 2022 09:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A90C433D6;
        Tue, 23 Aug 2022 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247454;
        bh=EKZDETK2wMS8ga13sw3/T56Jn7RQhNCk9lH3fLtohFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enC175gIAnNKQF/w2bP7ov5IkJ2XDJiOgLVBeSrEg3Op824Q54v9VQ/AALNnKhoyM
         4/OrXe0BNmKmH4AeOSq7VU7c+3PGDVxIfNPdn3CAoix8xUOux7O+v6g/2HIz8ZV1zx
         4nsVraFRK3o9S3uDcXiXEZ9jemBVxCK4qEGUkl+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 010/158] tracing: Have filter accept "common_cpu" to be consistent
Date:   Tue, 23 Aug 2022 10:25:42 +0200
Message-Id: <20220823080046.491607346@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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
@@ -168,6 +168,7 @@ static int trace_define_generic_fields(v
 
 	__generic_field(int, CPU, FILTER_CPU);
 	__generic_field(int, cpu, FILTER_CPU);
+	__generic_field(int, common_cpu, FILTER_CPU);
 	__generic_field(char *, COMM, FILTER_COMM);
 	__generic_field(char *, comm, FILTER_COMM);
 


