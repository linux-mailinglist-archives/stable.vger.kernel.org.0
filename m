Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91D65D868
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbjADQOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbjADQNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:13:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C941726E8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FED26179F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FE9C433D2;
        Wed,  4 Jan 2023 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848824;
        bh=R62n4egSXnpXXXnV23Ku4Dc8+S1ZEFpdcEOk5E62XXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gv3DfjIKgt6t14FnTq96CA8M/5xyu7Rxdigy+5LgARfJ1l190qtjBThahEdFaokdW
         edPMnRnxZAStRT43ZEZfpIRUhv5A8WRerlfFG6y6G7tUM6dD4JpY1al6bvSVJ8M6H5
         vTuxE22PpjtsZT/FMF17VOwlwohz4Xz7dw7AeyMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 090/207] tracing: Fix race where eprobes can be called before the event
Date:   Wed,  4 Jan 2023 17:05:48 +0100
Message-Id: <20230104160514.789565938@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit d5f30a7da8ea8e6450250275cec5670cee3c4264 upstream.

The flag that tells the event to call its triggers after reading the event
is set for eprobes after the eprobe is enabled. This leads to a race where
the eprobe may be triggered at the beginning of the event where the record
information is NULL. The eprobe then dereferences the NULL record causing
a NULL kernel pointer bug.

Test for a NULL record to keep this from happening.

Link: https://lore.kernel.org/linux-trace-kernel/20221116192552.1066630-1-rafaelmendsr@gmail.com/
Link: https://lore.kernel.org/all/20221117214249.2addbe10@gandalf.local.home/

Cc: stable@vger.kernel.org
Fixes: 7491e2c442781 ("tracing: Add a probe that attaches to trace events")
Reported-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -567,6 +567,9 @@ static void eprobe_trigger_func(struct e
 	if (unlikely(!rec))
 		return;
 
+	if (unlikely(!rec))
+		return;
+
 	__eprobe_trace_func(edata, rec);
 }
 


