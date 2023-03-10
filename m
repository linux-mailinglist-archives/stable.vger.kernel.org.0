Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EA96B49C5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbjCJPPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbjCJPPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:15:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE62111FBE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:06:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1DE8B822F6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC40C433D2;
        Fri, 10 Mar 2023 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460360;
        bh=RIsyR6whMXbKg3k1cPpKB6A48PtvOEvB6i6xg1+up/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPYJmiJ3ApCU1i0cELrobhZjTQFl5Df/Pcf22VVfRt3W34R4xwmZyl3lKSn5/Dc30
         LvDPnU0ofVdQnOZJTa28IkQ5QahR0BjeJMc3BeCfkr47TnIWIlVKoZqzYEwxezZwVP
         mhAQqVPG5gaBrCXlLf9NKFmvvAAa8uZPa3RSlSrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/529] PM: EM: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:37:30 +0100
Message-Id: <20230310133819.233282680@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 119b929dcff0f..334173fe6940e 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -72,10 +72,7 @@ static void em_debug_create_pd(struct device *dev)
 
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
2.39.2



