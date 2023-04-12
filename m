Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2E06DEE3D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjDLIlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjDLIkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100A2728D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 352DB6302E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437B9C4339B;
        Wed, 12 Apr 2023 08:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288713;
        bh=TwP3WKZPDC9x6OlSWUgrQsWgQAcAwBd7RTKtkwObbzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1ITzwAxJ+LMTe7gMVm5E+y6wBUTknXvcAarXfzdNzeYvTV+HN/25Ji79RDRtjL0B
         mc8Ya8Efw52zju8IwpASJl00DDLHfrnM9AsJLDIPGQ5aayhVkNfGXGqZvb7qjYLqiu
         QdPTjwN/V2RCitmgxMQOmyCSTEmJ1/un4PwFy63c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, mark.rutland@arm.com,
        ast@kernel.org, daniel@iogearbox.net,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 81/93] ftrace: Fix issue that direct->addr not restored in modify_ftrace_direct()
Date:   Wed, 12 Apr 2023 10:34:22 +0200
Message-Id: <20230412082826.557878834@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -5383,12 +5383,15 @@ int modify_ftrace_direct(unsigned long i
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


