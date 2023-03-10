Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534C56B4ABF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbjCJP0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbjCJP0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:26:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA59133DAA;
        Fri, 10 Mar 2023 07:15:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 152EAB82303;
        Fri, 10 Mar 2023 15:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50716C433EF;
        Fri, 10 Mar 2023 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461245;
        bh=dHotbitnGUdIopNw20MhJvLvqsb6KXrudSRC27coLOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJi1A64OaBaSOFLJp9yvTdY1ii7U8w6BBcQc60LGFnMOJLCrZF1jhLaw9wjpt7iTv
         KNX9KAVUxBO9YyVDWM2dVbLhSL0z1mJQ/eOFKY5ftNW3K0raIxctvDLu+yppUiPd8E
         EbrRGTfGdcrf/mJ9A8rrGThzhZQCdxok3r10tglw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/136] kernel/printk/index.c: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:43:16 +0100
Message-Id: <20230310133709.391804716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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



