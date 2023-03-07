Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A326AF408
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbjCGTMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbjCGTMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044C9749B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:56:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D071D61522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C370EC433D2;
        Tue,  7 Mar 2023 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215386;
        bh=KDczQ4TUofeTCEtnUIxOVq7ozM5OixljnBg2WERZ7c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRqcqBtP2M/Iqk6anhMnXYZFGO25jOMNWodzI8DwzgO1zDIU+EIpZyYfwfIqw/5HP
         f739lU5mU1h9olKaQXbFGkatnd4myrCJ4RuNgKfqSHUDh03EhFnAsB8lNsvkpR8mMx
         yvDFKRpXJ8kEnwO9w0gg0PhNJ4HmZ4+fSsI7ORug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 244/567] dm: remove flush_scheduled_work() during local_exit()
Date:   Tue,  7 Mar 2023 17:59:40 +0100
Message-Id: <20230307165916.538429662@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 0b22ff5360f5c4e11050b89206370fdf7dc0a226 ]

Commit acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred
device removal") switched from using system workqueue to a single
workqueue local to DM.  But it didn't eliminate the call to
flush_scheduled_work() that was introduced purely for the benefit of
deferred device removal with commit 2c140a246dc ("dm: allow remove to
be deferred").

Since DM core uses its own workqueue (and queue_work) there is no need
to call flush_scheduled_work() from local_exit().  local_exit()'s
destroy_workqueue(deferred_remove_workqueue) handles flushing work
started with queue_work().

Fixes: acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred device removal")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9dd2c2da075d9..82c561e3fc145 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -226,7 +226,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	unregister_blkdev(_major, _name);
-- 
2.39.2



