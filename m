Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2376D4863
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbjDCO2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbjDCO2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E224959D2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA5C61DB6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C67AC433D2;
        Mon,  3 Apr 2023 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532091;
        bh=iIimPAl3W7sA8efoe/qBB54Hy/DRWY0cczHHWIEH6Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Pk2ict6ZSzrFJSKP6XNjwRRom0KEPF+G5+rsHHCPICTqP47SuytyHO3gBLnc9VBi
         TedBf2hldKeByGUy87KgmpEO5XxvryVe2oILgZbaeusv1eVAFz9q4y1gBN/fM1OUy4
         Q897+bSXjb4aXUnSv1s3D6pcriOOGaA9Y2J0mwnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anton Gusev <aagusev@ispras.ru>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/173] tracing: Fix wrong return in kprobe_event_gen_test.c
Date:   Mon,  3 Apr 2023 16:08:59 +0200
Message-Id: <20230403140418.472793987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
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



