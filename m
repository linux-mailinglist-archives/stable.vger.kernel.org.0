Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241926B437E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjCJOPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjCJOOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:14:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CFD59E70
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F54261948
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ACFC433D2;
        Fri, 10 Mar 2023 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457607;
        bh=F9liIfmRQVktoAn8wyKTNdmFd0qpqDIml8xV+QZbMDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZlJ0Ul8Fk62Q3SYcmASxBxRwj55UuhqRJHADghVLMgklHZfSmNyxK2xPfJXDINGd
         J1ME7e450mPufZXnfwEuKkNsCR2cdE01teFHh2tGAluQSABZ1YfXVBB/PUjbmbE7/b
         5rATOGfymVs5XnEpawD190lckU8/s+dSmlGWctLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/200] drivers: base: component: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:32 +0100
Message-Id: <20230310133722.174045711@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

[ Upstream commit 8deb87b1e810dd558371e88ffd44339fbef27870 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230202141621.2296458-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/component.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 5eadeac6c5322..7dbf14a1d9157 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -125,7 +125,7 @@ static void component_debugfs_add(struct aggregate_device *m)
 
 static void component_debugfs_del(struct aggregate_device *m)
 {
-	debugfs_remove(debugfs_lookup(dev_name(m->parent), component_debugfs_dir));
+	debugfs_lookup_and_remove(dev_name(m->parent), component_debugfs_dir);
 }
 
 #else
-- 
2.39.2



