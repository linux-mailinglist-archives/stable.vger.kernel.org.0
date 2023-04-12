Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2906DEEE4
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjDLIqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjDLIp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F500F1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71253630AE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888DEC4339B;
        Wed, 12 Apr 2023 08:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289082;
        bh=+VgXcekNaZX5j4F/90GhBEJESkXAC+zuuS8mB+8CtDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkFvZlHDYl+obPVGcwFfAhOYGQgwXt+/hA666I9bPiLTyL7FpPOqPx1QKCnQeh5Pq
         /BbC8Vt4k8AKnrUGpu9alc6NLmQfjqhhprkR11kL0oSri1+f6l/y8ctrKRrum1y5fA
         3fhFZstHJM7w/cVR41VLseTWVsJ+JLWKrYgRodB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, mark.rutland@arm.com,
        ast@kernel.org, daniel@iogearbox.net,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 112/164] ftrace: Fix issue that direct->addr not restored in modify_ftrace_direct()
Date:   Wed, 12 Apr 2023 10:33:54 +0200
Message-Id: <20230412082841.379955310@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 2a2d8c51defb446e8d89a83f42f8e5cd529111e9 upstream.

Syzkaller report a WARNING: "WARN_ON(!direct)" in modify_ftrace_direct().

Root cause is 'direct->addr' was changed from 'old_addr' to 'new_addr' but
not restored if error happened on calling ftrace_modify_direct_caller().
Then it can no longer find 'direct' by that 'old_addr'.

To fix it, restore 'direct->addr' to 'old_addr' explicitly in error path.

Link: https://lore.kernel.org/linux-trace-kernel/20230330025223.1046087-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: <ast@kernel.org>
Cc: <daniel@iogearbox.net>
Fixes: 8a141dd7f706 ("ftrace: Fix modify_ftrace_direct.")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5557,12 +5557,15 @@ int modify_ftrace_direct(unsigned long i
 		ret = 0;
 	}
 
-	if (unlikely(ret && new_direct)) {
-		direct->count++;
-		list_del_rcu(&new_direct->next);
-		synchronize_rcu_tasks();
-		kfree(new_direct);
-		ftrace_direct_func_count--;
+	if (ret) {
+		direct->addr = old_addr;
+		if (unlikely(new_direct)) {
+			direct->count++;
+			list_del_rcu(&new_direct->next);
+			synchronize_rcu_tasks();
+			kfree(new_direct);
+			ftrace_direct_func_count--;
+		}
 	}
 
  out_unlock:


