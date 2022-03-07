Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22244CF6F5
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbiCGJmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240563AbiCGJlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B63919C26;
        Mon,  7 Mar 2022 01:37:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5DFD61315;
        Mon,  7 Mar 2022 09:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB796C340E9;
        Mon,  7 Mar 2022 09:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645874;
        bh=txZiybrD915wwKLju2sxLOgQZmzPqRXIaL4AxPBJ8fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/D7U+v8afo/mLEebYJKUEOdSZF4KEfEu10GAwZJ4EO17uyE9V8iqIeUXL80awLcL
         vHGhDZb1cXpwn5ZDLuI5+29vmOa5Ky5VKhC78osb4YFnsKSP2pY0EDoIrNwOsfwsVS
         w4DrYQWSihH709AP+IzL6QkCwHihzlsYNTZ2vpPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/262] tracing: Do not let synth_events block other dyn_event systems during create
Date:   Mon,  7 Mar 2022 10:16:47 +0100
Message-Id: <20220307091704.285254438@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit 4f67cca70c0f615e9cfe6ac42244f3416ec60877 ]

synth_events is returning -EINVAL if the dyn_event create command does
not contain ' \t'. This prevents other systems from getting called back.
synth_events needs to return -ECANCELED in these cases when the command
is not targeting the synth_event system.

Link: https://lore.kernel.org/linux-trace-devel/20210930223821.11025-1-beaub@linux.microsoft.com

Fixes: c9e759b1e8456 ("tracing: Rework synthetic event command parsing")
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_synth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 22db3ce95e74f..8c26092db8dee 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -2053,6 +2053,13 @@ static int create_synth_event(const char *raw_command)
 
 	last_cmd_set(raw_command);
 
+	name = raw_command;
+
+	/* Don't try to process if not our system */
+	if (name[0] != 's' || name[1] != ':')
+		return -ECANCELED;
+	name += 2;
+
 	p = strpbrk(raw_command, " \t");
 	if (!p) {
 		synth_err(SYNTH_ERR_INVALID_CMD, 0);
@@ -2061,12 +2068,6 @@ static int create_synth_event(const char *raw_command)
 
 	fields = skip_spaces(p);
 
-	name = raw_command;
-
-	if (name[0] != 's' || name[1] != ':')
-		return -ECANCELED;
-	name += 2;
-
 	/* This interface accepts group name prefix */
 	if (strchr(name, '/')) {
 		len = str_has_prefix(name, SYNTH_SYSTEM "/");
-- 
2.34.1



