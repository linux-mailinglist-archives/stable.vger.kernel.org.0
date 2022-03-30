Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69D4EC0B3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344219AbiC3Lwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344282AbiC3Lwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:52:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB102D1EA;
        Wed, 30 Mar 2022 04:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C2BB81ACC;
        Wed, 30 Mar 2022 11:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE3EC36AE2;
        Wed, 30 Mar 2022 11:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640902;
        bh=icWt1u/1HfNB3hGYEKebbhJ459UFUuNN2B8lJfpnt/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pegrzFxdlZMdfKX3rMzlDl5tt4YC7jjs256hZrj6iYJtEgrUUtMAyk+LXjaQjYlyD
         RFN06pOUoyRZigdDc6pVZr2yI7m83GEDt0Eopn/vCeNSqvIVqhSukRBeVL+G/Gz0CV
         ZSXpe1o2RPNVJztAZYBrY/pw7coz8aoIxKMBQlHGEIQF0ZuAbncDo/EgnkPhJGhAJg
         yxBY051DI0yVjzraVquCS+6UehE3H+8yKE5RaCYjrf8HL2mE1mmCbcopHWOYoJOkcK
         C8vLJnHlTkOz91QWcmKDdxWKJM8Dv6+GuRYvy27HrltDnwhkjFneuWV9bXBVPumm4R
         Ecb+r6xW0Nw2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.17 61/66] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
Date:   Wed, 30 Mar 2022 07:46:40 -0400
Message-Id: <20220330114646.1669334-61-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

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
index 3147614c1812..82515a687923 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2633,6 +2633,33 @@ static void update_event_printk(struct trace_event_call *call,
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
@@ -2668,6 +2695,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 					first = false;
 				}
 				update_event_printk(call, map[i]);
+				update_event_fields(call, map[i]);
 			}
 		}
 	}
-- 
2.34.1

