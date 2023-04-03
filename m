Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3966D4965
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbjDCOhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbjDCOht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:37:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ED417652
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09FBFB81CBD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508B8C433EF;
        Mon,  3 Apr 2023 14:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532646;
        bh=iIimPAl3W7sA8efoe/qBB54Hy/DRWY0cczHHWIEH6Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofXCDh95bnPPfI7cPk9OZzF4rR8CWo45HwK9RszvU0vIYtgt5rISrLK+L2PgCenjU
         2NlpafZSCd8xWVHIIaWHhDX+whPcafXjm5s6G85FyYsTSRdpIEIZTFuTKPM0JbZAAU
         I+DmBFxVq3jz/9nzIlrZCWFz1JZJXk1zmfa9kFQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anton Gusev <aagusev@ispras.ru>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/181] tracing: Fix wrong return in kprobe_event_gen_test.c
Date:   Mon,  3 Apr 2023 16:08:18 +0200
Message-Id: <20230403140417.190791519@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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



