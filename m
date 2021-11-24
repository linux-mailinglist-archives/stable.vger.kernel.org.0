Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF9D45C326
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352400AbhKXNft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351808AbhKXNdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:33:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E33A561BE4;
        Wed, 24 Nov 2021 12:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758422;
        bh=QUJUd3EzWEY6hmmcHCJEktrSysUSGvPSFFYsyluQJ/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGEDqBnI/cOqAQYdzRJ7UdNgCH2RAHZPkkc6mgQfZEtJ21uxMd67TI8l8dvR0jEFM
         T1MAlUsbKfeLivxOUkExAHjrqJtm7oufsoBG7EVHENLxOjvRg50Hp8npFWPOl3Q0/L
         +A1sXG5J0It1T7EWUVVs0QZoJ4wM8xn4eVTS1xYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/154] tracing/histogram: Do not copy the fixed-size char array field over the field size
Date:   Wed, 24 Nov 2021 12:57:40 +0100
Message-Id: <20211124115704.386196404@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 63f84ae6b82bb4dff672f76f30c6fd7b9d3766bc ]

Do not copy the fixed-size char array field of the events over
the field size. The histogram treats char array as a string and
there are 2 types of char array in the event, fixed-size and
dynamic string. The dynamic string (__data_loc) field must be
null terminated, but the fixed-size char array field may not
be null terminated (not a string, but just a data).
In that case, histogram can copy the data after the field.
This uses the original field size for fixed-size char array
field to restrict the histogram not to access over the original
field size.

Link: https://lkml.kernel.org/r/163673292822.195747.3696966210526410250.stgit@devnote2

Fixes: 02205a6752f2 (tracing: Add support for 'field variables')
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 1b7f90e00eb05..642e4645f6406 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1684,9 +1684,10 @@ static struct hist_field *create_hist_field(struct hist_trigger_data *hist_data,
 		if (!hist_field->type)
 			goto free;
 
-		if (field->filter_type == FILTER_STATIC_STRING)
+		if (field->filter_type == FILTER_STATIC_STRING) {
 			hist_field->fn = hist_field_string;
-		else if (field->filter_type == FILTER_DYN_STRING)
+			hist_field->size = field->size;
+		} else if (field->filter_type == FILTER_DYN_STRING)
 			hist_field->fn = hist_field_dynstring;
 		else
 			hist_field->fn = hist_field_pstring;
@@ -2624,7 +2625,7 @@ static inline void __update_field_vars(struct tracing_map_elt *elt,
 			char *str = elt_data->field_var_str[j++];
 			char *val_str = (char *)(uintptr_t)var_val;
 
-			strscpy(str, val_str, STR_VAR_LEN_MAX);
+			strscpy(str, val_str, val->size);
 			var_val = (u64)(uintptr_t)str;
 		}
 		tracing_map_set_var(elt, var_idx, var_val);
@@ -4472,7 +4473,7 @@ static void hist_trigger_elt_update(struct hist_trigger_data *hist_data,
 
 				str = elt_data->field_var_str[idx];
 				val_str = (char *)(uintptr_t)hist_val;
-				strscpy(str, val_str, STR_VAR_LEN_MAX);
+				strscpy(str, val_str, hist_field->size);
 
 				hist_val = (u64)(uintptr_t)str;
 			}
-- 
2.33.0



