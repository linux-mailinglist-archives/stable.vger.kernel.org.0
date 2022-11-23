Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E767E6358B4
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiKWKBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiKWKAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8E963B8C;
        Wed, 23 Nov 2022 01:53:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEDF461B87;
        Wed, 23 Nov 2022 09:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCC0C433C1;
        Wed, 23 Nov 2022 09:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197182;
        bh=r/KD+Loc1bRhvWnz5vxl9PaccKxnBDk2Ng7IRLJ8Wv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJwGAYMyEPVEhvPX6uALTtwJYkPWKOOkVB8ZSlYc9JgZAQFfenWLK21hdQf9a1swl
         YVN8e8Sv7efNq2Imb6S3Hpwx4c8QVc8211cwGFyP8bEEWqxUKCEfSUrq2gd2QwFFy0
         +BQ+WGqnxmfHpD0Piakp75S4bhjao16CsqMkxJFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Rafael Mendonca <rafaelmendsr@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 204/314] tracing: Fix race where eprobes can be called before the event
Date:   Wed, 23 Nov 2022 09:50:49 +0100
Message-Id: <20221123084634.797557114@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit 94eedf3dded5fb472ce97bfaf3ac1c6c29c35d26 upstream.

The flag that tells the event to call its triggers after reading the event
is set for eprobes after the eprobe is enabled. This leads to a race where
the eprobe may be triggered at the beginning of the event where the record
information is NULL. The eprobe then dereferences the NULL record causing
a NULL kernel pointer bug.

Test for a NULL record to keep this from happening.

Link: https://lore.kernel.org/linux-trace-kernel/20221116192552.1066630-1-rafaelmendsr@gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20221117214249.2addbe10@gandalf.local.home

Cc: Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 7491e2c442781 ("tracing: Add a probe that attaches to trace events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -560,6 +560,9 @@ static void eprobe_trigger_func(struct e
 {
 	struct eprobe_data *edata = data->private_data;
 
+	if (unlikely(!rec))
+		return;
+
 	__eprobe_trace_func(edata, rec);
 }
 


