Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17F6B4237
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjCJOAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjCJN7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:59:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4191F115DED
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:59:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1310B822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42779C433EF;
        Fri, 10 Mar 2023 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456786;
        bh=9HOBJ1TxNXYuQBwhsHcBeEMK8IuCImffiBxY3RwP/JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPUbq/PQmk/9jO6JGJOJJuInFOjwDUsmlVGY0pcSlwmqUyt0u4SxWcRpWy83d9A8P
         Wa2uwLqPie1kjK5RgRBBWEnzyc8NZbhDf8Fn/xRrPEOn495U+WsTv29kyEMJRuBxcx
         ogqRzrNPjO4GB7gbJgGNBQgLXfwW0bXx3s+O4dc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Eric Curtin <ecurtin@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 124/211] cpufreq: apple-soc: Fix an IS_ERR() vs NULL check
Date:   Fri, 10 Mar 2023 14:38:24 +0100
Message-Id: <20230310133722.498544116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f43523620f646c89ffd8ada840a0068290e51266 ]

The of_iomap() function returns NULL if it fails.  It never returns
error pointers.  Fix the check accordingly.

Fixes: 6286bbb40576 ("cpufreq: apple-soc: Add new driver to control Apple SoC CPU P-states")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/apple-soc-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/apple-soc-cpufreq.c b/drivers/cpufreq/apple-soc-cpufreq.c
index c11d22fd84c37..021f423705e1b 100644
--- a/drivers/cpufreq/apple-soc-cpufreq.c
+++ b/drivers/cpufreq/apple-soc-cpufreq.c
@@ -189,8 +189,8 @@ static int apple_soc_cpufreq_find_cluster(struct cpufreq_policy *policy,
 	*info = match->data;
 
 	*reg_base = of_iomap(args.np, 0);
-	if (IS_ERR(*reg_base))
-		return PTR_ERR(*reg_base);
+	if (!*reg_base)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.39.2



