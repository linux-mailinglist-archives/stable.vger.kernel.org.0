Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC13B6E0441
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDMCha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDMCgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3BF8694;
        Wed, 12 Apr 2023 19:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6A3D63A9E;
        Thu, 13 Apr 2023 02:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500D7C433D2;
        Thu, 13 Apr 2023 02:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353401;
        bh=gN79EhcNFLINcoVlQfIFEdwOuICOjlDUvsnTfSNzw4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3IGcXAVKAyxLOydPddWwcrjI9RH9dSTrUuEm0G4JAM+9HqnhUN+IIwIYfPJcr2hA
         ZVHCiQEBwglb2gKBi7C9uUvAL9HlbIooOdoPf79ykcNEKfsQxkaHSnoimKFRy4A9LK
         cVSo7OL1CDWoHsa0Ap3HbEH+ePimlJ5Rv+S0t3UprD7TapRTTzeHjEYOEaAj9V1M8f
         px6d02tjK+A3U4dbl2xVjgvVZpYNWi+5e77TL/Qp4RIq0UguWIWvLbmfflshAaXtlW
         BVDBv7NG61Br4wiImZBa4+qT2UYjeyuUx6EkesEnTVytsB1MMqWaTN1SHicQ+1oOdu
         4mahgzywd2/tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Douglas RAILLARD <douglas.raillard@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, vschneid@redhat.com,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 17/20] tracing: Error if a trace event has an array for a __field()
Date:   Wed, 12 Apr 2023 22:35:55 -0400
Message-Id: <20230413023601.74410-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023601.74410-1-sashal@kernel.org>
References: <20230413023601.74410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

[ Upstream commit f82e7ca019dfad3b006fd3b772f7ac569672db55 ]

A __field() in the TRACE_EVENT() macro is used to set up the fields of the
trace event data. It is for single storage units (word, char, int,
pointer, etc) and not for complex structures or arrays. Unfortunately,
there's nothing preventing the build from accepting:

    __field(int, arr[5]);

from building. It will turn into a array value. This use to work fine, as
the offset and size use to be determined by the macro using the field name,
but things have changed and the offset and size are now determined by the
type. So the above would only be size 4, and the next field will be
located 4 bytes from it (instead of 20).

The proper way to declare static arrays is to use the __array() macro.

Instead of __field(int, arr[5]) it should be __array(int, arr, 5).

Add some macro tricks to the building of a trace event from the
TRACE_EVENT() macro such that __field(int, arr[5]) will fail to build. A
comment by the failure will explain why the build failed.

Link: https://lore.kernel.org/lkml/20230306122549.236561-1-douglas.raillard@arm.com/
Link: https://lore.kernel.org/linux-trace-kernel/20230309221302.642e82d9@gandalf.local.home

Reported-by: Douglas RAILLARD <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/stages/stage5_get_offsets.h | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/trace/stages/stage5_get_offsets.h b/include/trace/stages/stage5_get_offsets.h
index ac5c24d3beeb2..e30a13be46ba5 100644
--- a/include/trace/stages/stage5_get_offsets.h
+++ b/include/trace/stages/stage5_get_offsets.h
@@ -9,17 +9,30 @@
 #undef __entry
 #define __entry entry
 
+/*
+ * Fields should never declare an array: i.e. __field(int, arr[5])
+ * If they do, it will cause issues in parsing and possibly corrupt the
+ * events. To prevent that from happening, test the sizeof() a fictitious
+ * type called "struct _test_no_array_##item" which will fail if "item"
+ * contains array elements (like "arr[5]").
+ *
+ * If you hit this, use __array(int, arr, 5) instead.
+ */
 #undef __field
-#define __field(type, item)
+#define __field(type, item)					\
+	{ (void)sizeof(struct _test_no_array_##item *); }
 
 #undef __field_ext
-#define __field_ext(type, item, filter_type)
+#define __field_ext(type, item, filter_type)			\
+	{ (void)sizeof(struct _test_no_array_##item *); }
 
 #undef __field_struct
-#define __field_struct(type, item)
+#define __field_struct(type, item)				\
+	{ (void)sizeof(struct _test_no_array_##item *); }
 
 #undef __field_struct_ext
-#define __field_struct_ext(type, item, filter_type)
+#define __field_struct_ext(type, item, filter_type)		\
+	{ (void)sizeof(struct _test_no_array_##item *); }
 
 #undef __array
 #define __array(type, item, len)
-- 
2.39.2

