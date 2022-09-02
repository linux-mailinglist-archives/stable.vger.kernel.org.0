Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F385AB02E
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbiIBMus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbiIBMtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:49:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43B8F47FF;
        Fri,  2 Sep 2022 05:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26896620DF;
        Fri,  2 Sep 2022 12:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B65BC433D7;
        Fri,  2 Sep 2022 12:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122170;
        bh=FwyuntaLgn+eoGAnS9FQ02m+oQ3R1jprZuuwFj9k02A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/WfIfYt19DOuUciIHx7QGhfiXyB4Ofy4eoI9oZNeFmNzVwKh8uWE7x+b25GhFQhZ
         0T+fA4ewYKsGw3zwL8p990lB6Abi4heg+cQjcGwyo7omRZQTzvzWyaT8ohAO6sgpmx
         HDeGbEhBLyfXLMalD/5tbl1Iw9XBJmdjLI6t2kkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Vicenzi <alexandre.vicenzi@suse.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 35/72] rtla: Fix tracer name
Date:   Fri,  2 Sep 2022 14:19:11 +0200
Message-Id: <20220902121405.945249417@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Alexandre Vicenzi <alexandre.vicenzi@suse.com>

[ Upstream commit f1432cd24c240cedf78c0d026631e3b10052c8e1 ]

The correct tracer name is timerlat and not timelat.

Link: https://lore.kernel.org/linux-trace-devel/20220808180343.22262-1-alexandre.vicenzi@suse.com

Signed-off-by: Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/tools/rtla/rtla-timerlat-hist.rst | 2 +-
 tools/tracing/rtla/src/timerlat_hist.c          | 2 +-
 tools/tracing/rtla/src/timerlat_top.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/tools/rtla/rtla-timerlat-hist.rst b/Documentation/tools/rtla/rtla-timerlat-hist.rst
index e12eae1f33019..6bf7f0ca45564 100644
--- a/Documentation/tools/rtla/rtla-timerlat-hist.rst
+++ b/Documentation/tools/rtla/rtla-timerlat-hist.rst
@@ -33,7 +33,7 @@ EXAMPLE
 =======
 In the example below, **rtla timerlat hist** is set to run for *10* minutes,
 in the cpus *0-4*, *skipping zero* only lines. Moreover, **rtla timerlat
-hist** will change the priority of the *timelat* threads to run under
+hist** will change the priority of the *timerlat* threads to run under
 *SCHED_DEADLINE* priority, with a *10us* runtime every *1ms* period. The
 *1ms* period is also passed to the *timerlat* tracer::
 
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index f3ec628f5e519..4b48af8a83096 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -892,7 +892,7 @@ int timerlat_hist_main(int argc, char *argv[])
 	return_value = 0;
 
 	if (trace_is_off(&tool->trace, &record->trace)) {
-		printf("rtla timelat hit stop tracing\n");
+		printf("rtla timerlat hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);
 			save_trace_to_file(record->trace.inst, params->trace_output);
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 35452a1d45e9f..3342719352222 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -687,7 +687,7 @@ int timerlat_top_main(int argc, char *argv[])
 	return_value = 0;
 
 	if (trace_is_off(&top->trace, &record->trace)) {
-		printf("rtla timelat hit stop tracing\n");
+		printf("rtla timerlat hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);
 			save_trace_to_file(record->trace.inst, params->trace_output);
-- 
2.35.1



