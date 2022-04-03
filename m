Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B204F0A2A
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 16:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359003AbiDCOdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 10:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358999AbiDCOdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 10:33:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F602FFED;
        Sun,  3 Apr 2022 07:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B094B80D58;
        Sun,  3 Apr 2022 14:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9219C340ED;
        Sun,  3 Apr 2022 14:31:40 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nb1GV-001EgK-Pm;
        Sun, 03 Apr 2022 10:31:39 -0400
Message-ID: <20220403143139.633512320@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 03 Apr 2022 10:25:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Zeal Robot <zealci@zte.com.cn>, Lv Ruyi <lv.ruyi@zte.com.cn>
Subject: [for-linus][PATCH 2/7] proc: bootconfig: Add null pointer check
References: <20220403142500.388473000@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

kzalloc is a memory allocation function which can return NULL when some
internal memory errors happen. It is safer to add null pointer check.

Link: https://lkml.kernel.org/r/20220329104004.2376879-1-lv.ruyi@zte.com.cn

Cc: stable@vger.kernel.org
Fixes: c1a3c36017d4 ("proc: bootconfig: Add /proc/bootconfig to show boot config list")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/proc/bootconfig.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/proc/bootconfig.c b/fs/proc/bootconfig.c
index 6d8d4bf20837..2e244ada1f97 100644
--- a/fs/proc/bootconfig.c
+++ b/fs/proc/bootconfig.c
@@ -32,6 +32,8 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
 	int ret = 0;
 
 	key = kzalloc(XBC_KEYLEN_MAX, GFP_KERNEL);
+	if (!key)
+		return -ENOMEM;
 
 	xbc_for_each_key_value(leaf, val) {
 		ret = xbc_node_compose_key(leaf, key, XBC_KEYLEN_MAX);
-- 
2.35.1
