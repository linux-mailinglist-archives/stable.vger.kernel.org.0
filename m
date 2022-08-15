Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BC859509B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiHPEoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiHPEms (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:42:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E76CABD6D;
        Mon, 15 Aug 2022 13:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35F13611FC;
        Mon, 15 Aug 2022 20:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293E0C43470;
        Mon, 15 Aug 2022 20:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595871;
        bh=WMHuwJF65OUTic2MXusj7pI//kwnDmHogdmjBJcNqpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsOnGz4K64V/czgj9Dd1ZQUsq5FI5cDWZQRNI4yrpR8KxHm+sdYlMLsLC30RpwFez
         u0rIySwjhIbEdri2GPCSUKDNbm7fbfQSVp0JaW62ndlzvO8g8kAB/y+ntxtQCh+UOJ
         joDhOGyfDTwjDsWzoQxxhcthSVx6ItsW11J7I7y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0869/1157] rtla: Fix double free
Date:   Mon, 15 Aug 2022 20:03:45 +0200
Message-Id: <20220815180514.237489066@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Andreas Schwab <schwab@suse.de>

[ Upstream commit 4f753c3be52c1d930afc0fe3169baa605dbaf611 ]

Avoid double free by making trace_instance_destroy indempotent.  When
trace_instance_init fails, it calls trace_instance_destroy, but its only
caller osnoise_destroy_tool calls it again.

Link: https://lkml.kernel.org/r/mvmilnlkyzx.fsf_-_@suse.de

Fixes: 0605bf009f18 ("rtla: Add osnoise tool")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/trace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/trace.c b/tools/tracing/rtla/src/trace.c
index 5784c9f9e570..e1ba6d9f4265 100644
--- a/tools/tracing/rtla/src/trace.c
+++ b/tools/tracing/rtla/src/trace.c
@@ -134,13 +134,18 @@ void trace_instance_destroy(struct trace_instance *trace)
 	if (trace->inst) {
 		disable_tracer(trace->inst);
 		destroy_instance(trace->inst);
+		trace->inst = NULL;
 	}
 
-	if (trace->seq)
+	if (trace->seq) {
 		free(trace->seq);
+		trace->seq = NULL;
+	}
 
-	if (trace->tep)
+	if (trace->tep) {
 		tep_free(trace->tep);
+		trace->tep = NULL;
+	}
 }
 
 /*
-- 
2.35.1



