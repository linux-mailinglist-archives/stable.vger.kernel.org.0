Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBA0595134
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiHPEwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiHPEvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9301EDB07F;
        Mon, 15 Aug 2022 13:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CB561275;
        Mon, 15 Aug 2022 20:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87E3C433C1;
        Mon, 15 Aug 2022 20:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596553;
        bh=fKV254h6rlaIOkZW+7MI6wx3Yxyt5S+adxZmtrAb6Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ic1xFufPguzJ5gaNTk23OipVHQn+Y2vknPFr3gaY8ZJ+uahO4sMRjNtov4gJ85cya
         6wy8QuoC+r7pMSyzKILrec3vlbDMcnNwb13G8K9fx07fh8W1MVpyd3GdY9At2WVkQG
         va41SWtJCF+9w2K6j26oewqnJkc1sVJ4LqX4psmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1115/1157] tracing: Use a struct alignof to determine trace event field alignment
Date:   Mon, 15 Aug 2022 20:07:51 +0200
Message-Id: <20220815180524.924236844@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 4c3d2f9388d36eb28640a220a6f908328442d873 ]

alignof() gives an alignment of types as they would be as standalone
variables. But alignment in structures might be different, and when
building the fields of events, the alignment must be the actual
alignment otherwise the field offsets may not match what they actually
are.

This caused trace-cmd to crash, as libtraceevent did not check if the
field offset was bigger than the event. The write_msr and read_msr
events on 32 bit had their fields incorrect, because it had a u64 field
between two ints. alignof(u64) would give 8, but the u64 field was at a
4 byte alignment.

Define a macro as:

   ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))

which gives the actual alignment of types in a structure.

Link: https://lkml.kernel.org/r/20220731015928.7ab3a154@rorschach.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 04ae87a52074e ("ftrace: Rework event_create_dir()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/stages/stage4_event_fields.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/trace/stages/stage4_event_fields.h b/include/trace/stages/stage4_event_fields.h
index c3790ec7a453..80d34f396555 100644
--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -2,16 +2,18 @@
 
 /* Stage 4 definitions for creating trace events */
 
+#define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))
+
 #undef __field_ext
 #define __field_ext(_type, _item, _filter_type) {			\
 	.type = #_type, .name = #_item,					\
-	.size = sizeof(_type), .align = __alignof__(_type),		\
+	.size = sizeof(_type), .align = ALIGN_STRUCTFIELD(_type),	\
 	.is_signed = is_signed_type(_type), .filter_type = _filter_type },
 
 #undef __field_struct_ext
 #define __field_struct_ext(_type, _item, _filter_type) {		\
 	.type = #_type, .name = #_item,					\
-	.size = sizeof(_type), .align = __alignof__(_type),		\
+	.size = sizeof(_type), .align = ALIGN_STRUCTFIELD(_type),	\
 	0, .filter_type = _filter_type },
 
 #undef __field
@@ -23,7 +25,7 @@
 #undef __array
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
-	.size = sizeof(_type[_len]), .align = __alignof__(_type),	\
+	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
 	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
 
 #undef __dynamic_array
-- 
2.35.1



