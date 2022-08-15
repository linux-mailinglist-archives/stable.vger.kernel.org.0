Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9627594936
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245052AbiHOXRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353300AbiHOXQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0ED147421;
        Mon, 15 Aug 2022 13:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90FCCB81142;
        Mon, 15 Aug 2022 20:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EF3C433D7;
        Mon, 15 Aug 2022 20:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593781;
        bh=UdYZI1riOsDbDH0atDWZkwjVT6LhIpkFlQ5M1a7XQrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqCzr65tPSvGxEnVJ8gXdZ/z5++5gxCsKiyGk6vILBJm6JkJxezn9n6VBng+U4x5C
         4O0Qr0g4CNyx0pF0Zgtvicu+TZ3i5qiN+Y02c+fOZ/TM/rOQmRhEdmrRMzHhNDHXW8
         33GipBMO55ziBxIo1dkv8y8djCogDyVNWa/100lQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Peter Chen <peter.chen@kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Bin Liu <b-liu@ti.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1005/1095] tracing/events: Add __vstring() and __assign_vstr() helper macros
Date:   Mon, 15 Aug 2022 20:06:44 +0200
Message-Id: <20220815180510.669145492@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 0563231f93c6d1f582b168a47753b345c1e20d81 ]

There's several places that open code the following logic:

  TP_STRUCT__entry(__dynamic_array(char, msg, MSG_MAX)),
  TP_fast_assign(vsnprintf(__get_str(msg), MSG_MAX, vaf->fmt, *vaf->va);)

To load a string created by variable array va_list.

The main issue with this approach is that "MSG_MAX" usage in the
__dynamic_array() portion. That actually just reserves the MSG_MAX in the
event, and even wastes space because there's dynamic meta data also saved
in the event to denote the offset and size of the dynamic array. It would
have been better to just use a static __array() field.

Instead, create __vstring() and __assign_vstr() that work like __string
and __assign_str() but instead of taking a destination string to copy,
take a format string and a va_list pointer and fill in the values.

It uses the helper:

 #define __trace_event_vstr_len(fmt, va)		\
 ({							\
	va_list __ap;					\
	int __ret;					\
							\
	va_copy(__ap, *(va));				\
	__ret = vsnprintf(NULL, 0, fmt, __ap) + 1;	\
	va_end(__ap);					\
							\
	min(__ret, TRACE_EVENT_STR_MAX);		\
 })

To figure out the length to store the string. It may be slightly slower as
it needs to run the vsnprintf() twice, but it now saves space on the ring
buffer.

Link: https://lkml.kernel.org/r/20220705224749.053570613@goodmis.org

Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Peter Chen <peter.chen@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: Bin Liu <b-liu@ti.com>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h                 | 18 ++++++++++++++++++
 include/trace/stages/stage1_struct_define.h  |  3 +++
 include/trace/stages/stage2_data_offsets.h   |  3 +++
 include/trace/stages/stage4_event_fields.h   |  3 +++
 include/trace/stages/stage5_get_offsets.h    |  4 ++++
 include/trace/stages/stage6_event_callback.h |  7 +++++++
 6 files changed, 38 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index e6e95a9f07a5..b18759a673c6 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -916,6 +916,24 @@ perf_trace_buf_submit(void *raw_data, int size, int rctx, u16 type,
 
 #endif
 
+#define TRACE_EVENT_STR_MAX	512
+
+/*
+ * gcc warns that you can not use a va_list in an inlined
+ * function. But lets me make it into a macro :-/
+ */
+#define __trace_event_vstr_len(fmt, va)			\
+({							\
+	va_list __ap;					\
+	int __ret;					\
+							\
+	va_copy(__ap, *(va));				\
+	__ret = vsnprintf(NULL, 0, fmt, __ap) + 1;	\
+	va_end(__ap);					\
+							\
+	min(__ret, TRACE_EVENT_STR_MAX);		\
+})
+
 #endif /* _LINUX_TRACE_EVENT_H */
 
 /*
diff --git a/include/trace/stages/stage1_struct_define.h b/include/trace/stages/stage1_struct_define.h
index a16783419687..1b7bab60434c 100644
--- a/include/trace/stages/stage1_struct_define.h
+++ b/include/trace/stages/stage1_struct_define.h
@@ -26,6 +26,9 @@
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, -1)
 
+#undef __vstring
+#define __vstring(item, fmt, ap) __dynamic_array(char, item, -1)
+
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(char, item, -1)
 
diff --git a/include/trace/stages/stage2_data_offsets.h b/include/trace/stages/stage2_data_offsets.h
index 42fd1e8813ec..1b7a8f764fdd 100644
--- a/include/trace/stages/stage2_data_offsets.h
+++ b/include/trace/stages/stage2_data_offsets.h
@@ -32,6 +32,9 @@
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, -1)
 
+#undef __vstring
+#define __vstring(item, fmt, ap) __dynamic_array(char, item, -1)
+
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
 
diff --git a/include/trace/stages/stage4_event_fields.h b/include/trace/stages/stage4_event_fields.h
index e80cdc397a43..c3790ec7a453 100644
--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -38,6 +38,9 @@
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, -1)
 
+#undef __vstring
+#define __vstring(item, fmt, ap) __dynamic_array(char, item, -1)
+
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
 
diff --git a/include/trace/stages/stage5_get_offsets.h b/include/trace/stages/stage5_get_offsets.h
index 7ee5931300e6..fba4c24ed9e6 100644
--- a/include/trace/stages/stage5_get_offsets.h
+++ b/include/trace/stages/stage5_get_offsets.h
@@ -39,6 +39,10 @@
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, (len) + 1)
 
+#undef __vstring
+#define __vstring(item, fmt, ap) __dynamic_array(char, item,		\
+		      __trace_event_vstr_len(fmt, ap))
+
 #undef __rel_dynamic_array
 #define __rel_dynamic_array(type, item, len)				\
 	__item_length = (len) * sizeof(type);				\
diff --git a/include/trace/stages/stage6_event_callback.h b/include/trace/stages/stage6_event_callback.h
index e1724f73594b..0f51f6b3ab70 100644
--- a/include/trace/stages/stage6_event_callback.h
+++ b/include/trace/stages/stage6_event_callback.h
@@ -24,6 +24,9 @@
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, -1)
 
+#undef __vstring
+#define __vstring(item, fmt, ap) __dynamic_array(char, item, -1)
+
 #undef __assign_str
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), (src) ? (const char *)(src) : "(null)");
@@ -35,6 +38,10 @@
 		__get_str(dst)[len] = '\0';				\
 	} while(0)
 
+#undef __assign_vstr
+#define __assign_vstr(dst, fmt, va)					\
+	vsnprintf(__get_str(dst), TRACE_EVENT_STR_MAX, fmt, *(va))
+
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
 
-- 
2.35.1



