Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEAA45C4BC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354536AbhKXNvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349632AbhKXNta (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A34B363356;
        Wed, 24 Nov 2021 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759000;
        bh=/n1HT/HlcrehERCWqyerXBvRn4Gv7V8/F6atG901g5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZS/0iBAa5gkuEZgfrKuOV2/Adcrpw/cY6Q6rjGlBvqtlT158YFXpgP1hVaZ+yDL7h
         xRDANEqVzBL7xaGDi6SrGuXjg4FtLF/Z5vTOsD/XlFHfwkNOjueHwaaPCaoaj6rLsM
         I3QSXDvLLeXTBh1k7Fitc3fDsB2o8wAWOtpDzQZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/279] tracing/histogram: Do not copy the fixed-size char array field over the field size
Date:   Wed, 24 Nov 2021 12:56:27 +0100
Message-Id: <20211124115722.226027433@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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
index f01e442716e2f..de37664ef0476 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1733,9 +1733,10 @@ static struct hist_field *create_hist_field(struct hist_trigger_data *hist_data,
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
@@ -2691,7 +2692,7 @@ static inline void __update_field_vars(struct tracing_map_elt *elt,
 			char *str = elt_data->field_var_str[j++];
 			char *val_str = (char *)(uintptr_t)var_val;
 
-			strscpy(str, val_str, STR_VAR_LEN_MAX);
+			strscpy(str, val_str, val->size);
 			var_val = (u64)(uintptr_t)str;
 		}
 		tracing_map_set_var(elt, var_idx, var_val);
@@ -4586,7 +4587,7 @@ static void hist_trigger_elt_update(struct hist_trigger_data *hist_data,
 
 				str = elt_data->field_var_str[idx];
 				val_str = (char *)(uintptr_t)hist_val;
-				strscpy(str, val_str, STR_VAR_LEN_MAX);
+				strscpy(str, val_str, hist_field->size);
 
 				hist_val = (u64)(uintptr_t)str;
 			}
-- 
2.33.0



