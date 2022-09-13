Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F05B6F6B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiIMOOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiIMONm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:13:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88F360530;
        Tue, 13 Sep 2022 07:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6383A614AD;
        Tue, 13 Sep 2022 14:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76162C433C1;
        Tue, 13 Sep 2022 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078231;
        bh=iBYgRVrrigG9a2PbB5yuKVYxd8dv9ZIpUNRk1qGDPWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWkC2QaRE3vAl3ZuY4MoZPnCVJIB7pv/6nsOadnr2n0KlkRk9mVewkhoMSSlA47z3
         S+cajq1cIbzl0mBH8TsrL23uHo2/PWr6udDmd6y2eFFdBDayyfQ6Eh2Za+mEtctHIg
         DEHa9boudCzKF05viNBpPDl9NaOa3X0G9w3xyDlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 044/192] tracing: Fix to check event_mutex is held while accessing trigger list
Date:   Tue, 13 Sep 2022 16:02:30 +0200
Message-Id: <20220913140412.116901302@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit cecf8e128ec69149fe53c9a7bafa505a4bee25d9 upstream.

Since the check_user_trigger() is called outside of RCU
read lock, this list_for_each_entry_rcu() caused a suspicious
RCU usage warning.

 # echo hist:keys=pid > events/sched/sched_stat_runtime/trigger
 # cat events/sched/sched_stat_runtime/trigger
[   43.167032]
[   43.167418] =============================
[   43.167992] WARNING: suspicious RCU usage
[   43.168567] 5.19.0-rc5-00029-g19ebe4651abf #59 Not tainted
[   43.169283] -----------------------------
[   43.169863] kernel/trace/trace_events_trigger.c:145 RCU-list traversed in non-reader section!!
...

However, this file->triggers list is safe when it is accessed
under event_mutex is held.
To fix this warning, adds a lockdep_is_held check to the
list_for_each_entry_rcu().

Link: https://lkml.kernel.org/r/166226474977.223837.1992182913048377113.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -142,7 +142,8 @@ static bool check_user_trigger(struct tr
 {
 	struct event_trigger_data *data;
 
-	list_for_each_entry_rcu(data, &file->triggers, list) {
+	list_for_each_entry_rcu(data, &file->triggers, list,
+				lockdep_is_held(&event_mutex)) {
 		if (data->flags & EVENT_TRIGGER_FL_PROBE)
 			continue;
 		return true;


