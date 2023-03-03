Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB96C6AA288
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjCCVsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjCCVsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:48:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9591D66D12;
        Fri,  3 Mar 2023 13:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4DA161956;
        Fri,  3 Mar 2023 21:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD732C433A1;
        Fri,  3 Mar 2023 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879904;
        bh=xp9FXqujjwu2ZzrM0tPwlrfBuZ8IpUHdD1atRn/3w/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwXEPgk00XdsFNKkMAOJunGgsmGRRUGi+quG7zZQXTxS9dpPCQ9yqk+kpff0wuaLO
         mtFqlO1ZTxIPBM4F3uYiMZ2XEf5y0HCU7JgoMUNdfR4XWIWzaiqIUnCtdS5rVTtqeB
         9d47zh5u/sYFEwG1JjzzQueKWRGiFqBQj+fP05ec6EcBmmgf3iPz+djjCP/9MXsc8o
         HE6Ak+n3wwuGJq4Mga9EwqdJJYSxu0lpM3bcoFHQD/BfIPnb+jkRIKar9ggiFr3fiT
         63+35AfvGSN2pRysylWvsCu5OVYcQrlfOGTOiHy/eEybo/1aN1EWxBEa9EoJ3KW7Ob
         XQQRTCScWrJSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 51/60] kernel/power/energy_model.c: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:43:05 -0500
Message-Id: <20230303214315.1447666-51-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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

[ Upstream commit a0bc3f78d0fffa8be1a73bf945a43bfe1c2871c1 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Link: https://lore.kernel.org/r/20230202151515.2309543-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.39.2

