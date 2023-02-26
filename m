Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20456A30CF
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjBZOxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjBZOwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:52:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E3B13D7B;
        Sun, 26 Feb 2023 06:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F91660C40;
        Sun, 26 Feb 2023 14:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49094C433EF;
        Sun, 26 Feb 2023 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422898;
        bh=CYx/ymQhQfmjFox7JL4R9cjKSnWB/RkxeJDytUG4sGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSfVzwkvs0cl4Zf8DFIkMxqA5Kydml1knueCPA/NGA4uex848Foom6NkIj/JOTyjL
         /4Iueeln3kZPtaTTdqJSi750auPoK2SfjYhYOGs7stiL6mXYh1ki1aa05ZdXCUcCao
         ymf+kzsXCsVuQqPY5szbmKM4pYw94veOEr3Wa2E/vM5pg5I5EKIFp/AvTWx8daKdbN
         Y5obBbIaw9U+jfzGBCkoN0fnrwDFETG9ZJybPTPs/39L1oYNGJSTVwAi+GHLKNPHdk
         JRvrpe9zKjbJOnQRKRnqrHKMCA8+f2CeI6QqweIzN1Ff88QWOc5rnBCN20w2eB5OOX
         UulUXDWRM5r1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 38/49] time/debug: Fix memory leak with using debugfs_lookup()
Date:   Sun, 26 Feb 2023 09:46:38 -0500
Message-Id: <20230226144650.826470-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
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

[ Upstream commit 5b268d8abaec6cbd4bd70d062e769098d96670aa ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic at
once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230202151214.2306822-1-gregkh@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/test_udelay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/test_udelay.c b/kernel/time/test_udelay.c
index 13b11eb62685e..20d5df631570e 100644
--- a/kernel/time/test_udelay.c
+++ b/kernel/time/test_udelay.c
@@ -149,7 +149,7 @@ module_init(udelay_test_init);
 static void __exit udelay_test_exit(void)
 {
 	mutex_lock(&udelay_test_lock);
-	debugfs_remove(debugfs_lookup(DEBUGFS_FILENAME, NULL));
+	debugfs_lookup_and_remove(DEBUGFS_FILENAME, NULL);
 	mutex_unlock(&udelay_test_lock);
 }
 
-- 
2.39.0

