Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ACF4F6653
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 19:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbiDFRFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 13:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238255AbiDFRFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 13:05:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151C34961FB;
        Wed,  6 Apr 2022 07:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA4EB82353;
        Wed,  6 Apr 2022 14:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9470DC385A3;
        Wed,  6 Apr 2022 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255316;
        bh=6ilL6lDyJxwwFSqe1lKQGv1TTtCGzwxuY6CWzqW3O/c=;
        h=From:To:Cc:Subject:Date:From;
        b=hgjDMg8XINxqdmkR9f8AdMKEfhxzsrPumb8XbUGwhvsXdS8enBomrRCBxL1/fdeo5
         HJXRIG5UrwQhajTiMS5314t15cGqDyjEvjRWm5qzPCBqqZ1f+lT9+TrWA0HWOjVclP
         IA4bL8acXWbzqz2lbWLWN1OcqKnUVTpACzoQ8UL0ZJwB7KH9REsfITVpxRtYvIXmsJ
         +okbrVHjHzaBSkbpT5+heKmhrQQfLxLFCFQVuj8mWVe7GC1QISj6XJhMA98RzCrJAq
         atD8tYueuk2mvgnMMjuCNWsuJ3Ze9nxiNIZytrDh035g383swaQ/RKiqxAtRqvp9nQ
         JkjUqGSadJQTA==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de, jcmvbkbc@gmail.com,
        chris@zankel.net
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, Guo Ren <guoren@linux.alibaba.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V3] xtensa: patch_text: Fixup last cpu should be master
Date:   Wed,  6 Apr 2022 22:28:19 +0800
Message-Id: <20220406142819.730238-1-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Guo Ren <guoren@linux.alibaba.com>

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/xtensa/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/jump_label.c b/arch/xtensa/kernel/jump_label.c
index 0dde21e0d3de..ad1841cecdfb 100644
--- a/arch/xtensa/kernel/jump_label.c
+++ b/arch/xtensa/kernel/jump_label.c
@@ -40,7 +40,7 @@ static int patch_text_stop_machine(void *data)
 {
 	struct patch *patch = data;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		local_patch_text(patch->addr, patch->data, patch->sz);
 		atomic_inc(&patch->cpu_count);
 	} else {
-- 
2.25.1

