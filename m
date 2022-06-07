Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302B6541D04
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383675AbiFGWHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383720AbiFGWGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51974196A97;
        Tue,  7 Jun 2022 12:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E27A661846;
        Tue,  7 Jun 2022 19:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5ABC385A5;
        Tue,  7 Jun 2022 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629439;
        bh=SlBPGji7woA4rGOeBaUnM7hABHCKRDfgOmNlCjm/ZjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYn3b8Zxeeew95NSR6KksHcLtSGiugutbXinLSc1cbjdc5DDtwQvoQmiHPqIc7QvH
         0PY/JQn2Hq714dyWLrw9GbsZojd1q6D4VVHxPCvSe5yRJmKOHoAncyXfv3Y8ttVN9o
         FmhuujlyeF1hhNGPgZoCBHgW/M7ydDQYwof7It3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 692/879] tracing: Reset the function filter after completing trampoline/graph selftest
Date:   Tue,  7 Jun 2022 19:03:30 +0200
Message-Id: <20220607165022.935562268@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit e35c2d8e22745751cf304ec3fe39616643db2e0a ]

The direct trampoline and graph coexistence test sets global_ops to
trace only 'trace_selftest_dynamic_test_func', but does not reset it
after the test is completed, resulting in the function filter being set
already after the system starts. Although it can be reset through the
tracefs interface, it is more or less confusing to the user, and we
should reset it to trace all functions after the trampoline/graph test
completes.

Link: https://lkml.kernel.org/r/20220427034119.24668-1-lihuafei1@huawei.com
Link: https://lore.kernel.org/all/20220418073958.104029-1-lihuafei1@huawei.com/

Fixes: 130c08065848 ("tracing: Add trampoline/graph selftest")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_selftest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index abcadbe933bb..a2d301f58ced 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -895,6 +895,9 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 		ret = -1;
 		goto out;
 	}
+
+	/* Enable tracing on all functions again */
+	ftrace_set_global_filter(NULL, 0, 1);
 #endif
 
 	/* Don't test dynamic tracing, the function tracer already did */
-- 
2.35.1



