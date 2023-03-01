Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798826A7104
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCAQad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCAQaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:30:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A8648E2F;
        Wed,  1 Mar 2023 08:29:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E95ECB810BF;
        Wed,  1 Mar 2023 16:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CA4C433D2;
        Wed,  1 Mar 2023 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688193;
        bh=dHotbitnGUdIopNw20MhJvLvqsb6KXrudSRC27coLOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLaBmumLOiFvx8T+c49ojYwz9VHhCtYYLKvVGFBD6z+IxpyFC+ofK13GnTQLvrvmU
         7HBt+f7fjusYrO9S3F1+zwPutxSjocAF+E6FKh/xoSjzQBf7k/8EpE/a8s/+AiCMOQ
         GBZD+VwGSMK80F2PASCFRkPB0fLjDR1HPzs3o9TDwimjhUycLB0mazLXFLrw/TOb9o
         1bObIUhc+1Drb/0Kl5oC07WqybiRNcOFP4/xOyEUjpz48zRml4kP9isZF5Su57n1i9
         hrfuLhGa2aPsLxulMQr8W4z98qxdWsqwurcqUdS3bTfW8gafSNpu4Q+ndbX8UbASLe
         qwEAEbKPjhfpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 3/6] kernel/printk/index.c: fix memory leak with using debugfs_lookup()
Date:   Wed,  1 Mar 2023 11:29:45 -0500
Message-Id: <20230301162948.1302994-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162948.1302994-1-sashal@kernel.org>
References: <20230301162948.1302994-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 55bf243c514553e907efcf2bda92ba090eca8c64 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Chris Down <chris@chrisdown.name>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230202151411.2308576-1-gregkh@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/index.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/index.c b/kernel/printk/index.c
index d3709408debe9..d23b8f8a51db5 100644
--- a/kernel/printk/index.c
+++ b/kernel/printk/index.c
@@ -146,7 +146,7 @@ static void pi_create_file(struct module *mod)
 #ifdef CONFIG_MODULES
 static void pi_remove_file(struct module *mod)
 {
-	debugfs_remove(debugfs_lookup(pi_get_module_name(mod), dfs_index));
+	debugfs_lookup_and_remove(pi_get_module_name(mod), dfs_index);
 }
 
 static int pi_module_notify(struct notifier_block *nb, unsigned long op,
-- 
2.39.2

