Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9F74ABD0F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbiBGLok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385022AbiBGLa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84F8C03BFFF;
        Mon,  7 Feb 2022 03:29:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5297D60B5C;
        Mon,  7 Feb 2022 11:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F849C004E1;
        Mon,  7 Feb 2022 11:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233340;
        bh=ztI+U6AJfXgJOfHa3JGdlrmkcr9HcxcswIQ5WY5SUUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jpesOpgkmwLZgETVuLO6y5dub6AaoumPwmN168Pl7HtTgKR5fPusfve/Wi3wdOMw
         C1KSk79jPEKbyS4DEEk0L2GFTY5FjxIcbt0Y2DlnlqnM1GFxSliXUC5CStkcI/5DMy
         e92sR7WQ/3p04lQy84P82+mX2Ees12p9CmBojddw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/110] perf: Copy perf_event_attr::sig_data on modification
Date:   Mon,  7 Feb 2022 12:07:06 +0100
Message-Id: <20220207103805.549583830@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Marco Elver <elver@google.com>

[ Upstream commit 3c25fc97f5590060464cabfa25710970ecddbc96 ]

The intent has always been that perf_event_attr::sig_data should also be
modifiable along with PERF_EVENT_IOC_MODIFY_ATTRIBUTES, because it is
observable by user space if SIGTRAP on events is requested.

Currently only PERF_TYPE_BREAKPOINT is modifiable, and explicitly copies
relevant breakpoint-related attributes in hw_breakpoint_copy_attr().
This misses copying perf_event_attr::sig_data.

Since sig_data is not specific to PERF_TYPE_BREAKPOINT, introduce a
helper to copy generic event-type-independent attributes on
modification.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://lore.kernel.org/r/20220131103407.1971678-1-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c7581e3fb8ab1..69c70767b5dff 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3234,6 +3234,15 @@ static int perf_event_modify_breakpoint(struct perf_event *bp,
 	return err;
 }
 
+/*
+ * Copy event-type-independent attributes that may be modified.
+ */
+static void perf_event_modify_copy_attr(struct perf_event_attr *to,
+					const struct perf_event_attr *from)
+{
+	to->sig_data = from->sig_data;
+}
+
 static int perf_event_modify_attr(struct perf_event *event,
 				  struct perf_event_attr *attr)
 {
@@ -3256,10 +3265,17 @@ static int perf_event_modify_attr(struct perf_event *event,
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 
 	mutex_lock(&event->child_mutex);
+	/*
+	 * Event-type-independent attributes must be copied before event-type
+	 * modification, which will validate that final attributes match the
+	 * source attributes after all relevant attributes have been copied.
+	 */
+	perf_event_modify_copy_attr(&event->attr, attr);
 	err = func(event, attr);
 	if (err)
 		goto out;
 	list_for_each_entry(child, &event->child_list, child_list) {
+		perf_event_modify_copy_attr(&child->attr, attr);
 		err = func(child, attr);
 		if (err)
 			goto out;
-- 
2.34.1



