Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D565945F7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348115AbiHOWUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350874AbiHOWSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA28A65827;
        Mon, 15 Aug 2022 12:42:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B368B80EA9;
        Mon, 15 Aug 2022 19:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9890CC433C1;
        Mon, 15 Aug 2022 19:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592574;
        bh=WMHuwJF65OUTic2MXusj7pI//kwnDmHogdmjBJcNqpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMjr+6xnfIH6EkyoCuF+aMeJRdQF/hMNwZblbzih6+IYNpy1b3xf9zDsmX5LnmkaD
         CkZpExMfwmooH4i0FWqJ0Zt2i5/l2++IhqZ37g0QDRztJ+ZkRY6SBhO5TKw54LlhiZ
         yMAzJJ7GDcANosB+sDQLkYB6v0vp5vcfa1vTJAKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0810/1095] rtla: Fix double free
Date:   Mon, 15 Aug 2022 20:03:29 +0200
Message-Id: <20220815180502.775652783@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



