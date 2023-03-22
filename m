Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC256C564F
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjCVUEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjCVUDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:03:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07EE6C6AF;
        Wed, 22 Mar 2023 12:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE60BB81DE5;
        Wed, 22 Mar 2023 19:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E099EC433A0;
        Wed, 22 Mar 2023 19:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515165;
        bh=iIimPAl3W7sA8efoe/qBB54Hy/DRWY0cczHHWIEH6Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7/ZmWa1D527vgcLz1DILDld1MP7POm75akPVJnBlrFEsXYpEq5DypwchBbo5aZj0
         p9mFVkGKSggakysAqmXFJDFTt8SLiyrqpAbFEfx/Mc3AKzY207a6j4ponU70R+TWSG
         K0NSs27NEY0S652YuOzw1yrO8mLuWGZmZnmUO8uCOgibgkG3TBO/jvnnIEJ4uoFe2c
         I42uqjjVjqU4QsNrh0EIO+o/4PHwUb74UDLbGz9E9uEJAzM0O9SYaUF4MQrOspmqSK
         u6B8u0Q1eWhKTd0ZC1qF61dG2yLOedV1rVO/vtzUbfVZ4rvyYbkJKeFq8p41Ra6ysU
         yXqMkeSrfyrZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Gusev <aagusev@ispras.ru>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 45/45] tracing: Fix wrong return in kprobe_event_gen_test.c
Date:   Wed, 22 Mar 2023 15:56:39 -0400
Message-Id: <20230322195639.1995821-45-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Gusev <aagusev@ispras.ru>

[ Upstream commit bc4f359b3b607daac0290d0038561237a86b38cb ]

Overwriting the error code with the deletion result may cause the
function to return 0 despite encountering an error. Commit b111545d26c0
("tracing: Remove the useless value assignment in
test_create_synth_event()") solves a similar issue by
returning the original error code, so this patch does the same.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lore.kernel.org/linux-trace-kernel/20230131075818.5322-1-aagusev@ispras.ru

Signed-off-by: Anton Gusev <aagusev@ispras.ru>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/kprobe_event_gen_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index c736487fc0e48..e0c420eb0b2b4 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -146,7 +146,7 @@ static int __init test_gen_kprobe_cmd(void)
 	if (trace_event_file_is_valid(gen_kprobe_test))
 		gen_kprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
-	ret = kprobe_event_delete("gen_kprobe_test");
+	kprobe_event_delete("gen_kprobe_test");
 	goto out;
 }
 
@@ -211,7 +211,7 @@ static int __init test_gen_kretprobe_cmd(void)
 	if (trace_event_file_is_valid(gen_kretprobe_test))
 		gen_kretprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
-	ret = kprobe_event_delete("gen_kretprobe_test");
+	kprobe_event_delete("gen_kretprobe_test");
 	goto out;
 }
 
-- 
2.39.2

