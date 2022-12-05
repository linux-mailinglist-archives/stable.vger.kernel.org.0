Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6696432E9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLETcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiLETbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:31:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924642C678
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:27:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0435061314
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A45C433D6;
        Mon,  5 Dec 2022 19:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268429;
        bh=2qrNcdi3q9e7wrhLinHLfNcp86c0LHO60Bv0vmkR1RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRU6q2eXKcB9XoxEgzsUGg4TEZ7AHy7mWCfdDI845OK4teX37ZQjlY87AR90/2Uvj
         nC5B4H39d7do9exyXQW2+LRFFD5+w0lfPfFEhw+xsYMz6hl9yrIrF5sk3hLyGSUY41
         hH/bIcVbHB+ctf0qrBZV3otHNyBIHyrblmRF+qVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 099/124] tracing: Fix race where histograms can be called before the event
Date:   Mon,  5 Dec 2022 20:10:05 +0100
Message-Id: <20221205190811.227075300@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit ef38c79a522b660f7f71d45dad2d6244bc741841 upstream.

commit 94eedf3dded5 ("tracing: Fix race where eprobes can be called before
the event") fixed an issue where if an event is soft disabled, and the
trigger is being added, there's a small window where the event sees that
there's a trigger but does not see that it requires reading the event yet,
and then calls the trigger with the record == NULL.

This could be solved with adding memory barriers in the hot path, or to
make sure that all the triggers requiring a record check for NULL. The
latter was chosen.

Commit 94eedf3dded5 set the eprobe trigger handle to check for NULL, but
the same needs to be done with histograms.

Link: https://lore.kernel.org/linux-trace-kernel/20221118211809.701d40c0f8a757b0df3c025a@kernel.org/
Link: https://lore.kernel.org/linux-trace-kernel/20221123164323.03450c3a@gandalf.local.home

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 7491e2c442781 ("tracing: Add a probe that attaches to trace events")
Reported-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5051,6 +5051,9 @@ static void event_hist_trigger(struct ev
 	void *key = NULL;
 	unsigned int i;
 
+	if (unlikely(!rbe))
+		return;
+
 	memset(compound_key, 0, hist_data->key_size);
 
 	for_each_hist_key_field(i, hist_data) {


