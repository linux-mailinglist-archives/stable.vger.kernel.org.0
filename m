Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6914F425B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382781AbiDEMQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244608AbiDEKjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A50C8CCCE;
        Tue,  5 Apr 2022 03:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDFB5CE1B5F;
        Tue,  5 Apr 2022 10:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0625BC385A2;
        Tue,  5 Apr 2022 10:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154239;
        bh=vKmHDYIwdqH95tQq1Mx9F4Wf1YCePv0Duk6YZ99qoJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyi5nl84xpsIzFOOfGdKxLphQK4roYeoo7+tYDYFNyhlfOx9/Wl10Gj/NdeO2B32L
         nHOqDXVfxqnTNoMWwzOy+TFomB+dDOy8N9nqCdG595aApd21MZcjkrGyQ9v7BDmTt4
         HapKtqPA9+6ATAd/zVSKiokExHiJTucv/Pl8aJCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 508/599] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
Date:   Tue,  5 Apr 2022 09:33:22 +0200
Message-Id: <20220405070313.946159616@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit b3bc8547d3be60898818885f5bf22d0a62e2eb48 ]

The macro TRACE_DEFINE_ENUM is used to convert enums in the kernel to
their actual value when they are exported to user space via the trace
event format file.

Currently only the enums in the "print fmt" (TP_printk in the TRACE_EVENT
macro) have the enums converted. But the enums can be used to denote array
size:

        field:unsigned int fc_ineligible_rc[EXT4_FC_REASON_MAX]; offset:12;      size:36;        signed:0;

The EXT4_FC_REASON_MAX has no meaning to userspace but it needs to know
that information to know how to parse the array.

Have the array indexes also be parsed as well.

Link: https://lore.kernel.org/all/cover.1646922487.git.riteshh@linux.ibm.com/

Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Tested-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7cc5f0a77c3c..bbafea929008 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2417,6 +2417,33 @@ static void update_event_printk(struct trace_event_call *call,
 	}
 }
 
+static void update_event_fields(struct trace_event_call *call,
+				struct trace_eval_map *map)
+{
+	struct ftrace_event_field *field;
+	struct list_head *head;
+	char *ptr;
+	int len = strlen(map->eval_string);
+
+	head = trace_get_fields(call);
+	list_for_each_entry(field, head, link) {
+		ptr = strchr(field->type, '[');
+		if (!ptr)
+			continue;
+		ptr++;
+
+		if (!isalpha(*ptr) && *ptr != '_')
+			continue;
+
+		if (strncmp(map->eval_string, ptr, len) != 0)
+			continue;
+
+		ptr = eval_replace(ptr, map, len);
+		/* enum/sizeof string smaller than value */
+		WARN_ON_ONCE(!ptr);
+	}
+}
+
 void trace_event_eval_update(struct trace_eval_map **map, int len)
 {
 	struct trace_event_call *call, *p;
@@ -2452,6 +2479,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 					first = false;
 				}
 				update_event_printk(call, map[i]);
+				update_event_fields(call, map[i]);
 			}
 		}
 	}
-- 
2.34.1



