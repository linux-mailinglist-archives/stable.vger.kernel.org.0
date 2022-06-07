Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403EA541599
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356523AbiFGUgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378071AbiFGUes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512921E96D5;
        Tue,  7 Jun 2022 11:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E35661564;
        Tue,  7 Jun 2022 18:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADECC36B03;
        Tue,  7 Jun 2022 18:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627041;
        bh=SlBPGji7woA4rGOeBaUnM7hABHCKRDfgOmNlCjm/ZjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4wtaeu3AwHYMS7NRoflTlrOxaxYSlcouOaVROFHfEnNMh3yBvWdSP5ND4sbuVihj
         HPm8NKV1XEuqI9a3m2FGPr5pK5OmiY/qL8x7Z1Y2Z+5U0GFoqbFd7lWVbld4nyB4GB
         eXkp3Jto2fNLiDTaSToFsoSOgrljZLYyp+3AKkls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 595/772] tracing: Reset the function filter after completing trampoline/graph selftest
Date:   Tue,  7 Jun 2022 19:03:07 +0200
Message-Id: <20220607165006.475470301@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



