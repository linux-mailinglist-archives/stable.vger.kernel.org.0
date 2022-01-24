Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D43B49A49C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369562AbiAYACJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585430AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D882CC06137A;
        Mon, 24 Jan 2022 13:33:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766EA61305;
        Mon, 24 Jan 2022 21:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D0FC340E4;
        Mon, 24 Jan 2022 21:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059992;
        bh=1gE0J90otQHDAvwfXnYKScuN2a71uYD8y8dwjg4ylJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqUoJFtGiS6sb395vkGUK5NbzkXNDj6BO0UvNs9rkI/MKIq/wBVEWoBqJRq3LvFeX
         npw2vmYLaq9KrvJjTbLFMZLOid8iWXbciFOjUqNb8ZkWISmCOIu3/zjoF6P6Tf7eQh
         sL0kaTvsmZTV8CvA72j3ldShAm+iGiEPc2qZIrN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0796/1039] tracing: Do not let synth_events block other dyn_event systems during create
Date:   Mon, 24 Jan 2022 19:43:05 +0100
Message-Id: <20220124184152.059694230@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index ca9c13b2ecf4b..4b5a637d3ec00 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -2054,6 +2054,13 @@ static int create_synth_event(const char *raw_command)
 
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
@@ -2062,12 +2069,6 @@ static int create_synth_event(const char *raw_command)
 
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



