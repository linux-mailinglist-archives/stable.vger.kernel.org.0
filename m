Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A209F6A3120
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjBZO4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbjBZOzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:55:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03EA1BAE9;
        Sun, 26 Feb 2023 06:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05FCF60C56;
        Sun, 26 Feb 2023 14:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F3FC4339B;
        Sun, 26 Feb 2023 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422901;
        bh=qHyBzb5+zGty8cO7BL/qcrPFXMs8pVI2J/iGBv0oU30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRPmZ70xeK5/o9+NUSZxm+POWlZAiOVeevgI4yVBIttwBxgPJ8+ottj+bmOE1KSQz
         dHRpCZT18WyPR8gMlgmrQJLM7utFboXhTpYB51jvmPCbj+jY7PmM9ni2uuaPkjFGfR
         RPKL9Enqvb1O1UU89/GEFq7RlHop1lXz5MYFah/S8ZAMdre0I2vPK6v8jMDImKQSOd
         1h6SLN2WUaHkeeoChHFJ9YhPfwxkxCnok54eBxIk2P97181K5CIwPlgVPX6i9ts5gr
         owomd7cKzP9WKby58dZYJMkoZ6u1kiKNI/47HJIyZWTUTDh6ra7+q6O+U6rT76kXw/
         RTwc/OtK4JpbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 40/49] PM: EM: fix memory leak with using debugfs_lookup()
Date:   Sun, 26 Feb 2023 09:46:40 -0500
Message-Id: <20230226144650.826470-40-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit a0e8c13ccd6a9a636d27353da62c2410c4eca337 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index f82111837b8d1..7b44f5b89fa15 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -87,10 +87,7 @@ static void em_debug_create_pd(struct device *dev)
 
 static void em_debug_remove_pd(struct device *dev)
 {
-	struct dentry *debug_dir;
-
-	debug_dir = debugfs_lookup(dev_name(dev), rootdir);
-	debugfs_remove_recursive(debug_dir);
+	debugfs_lookup_and_remove(dev_name(dev), rootdir);
 }
 
 static int __init em_debug_init(void)
-- 
2.39.0

