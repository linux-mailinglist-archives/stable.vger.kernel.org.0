Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706114F261C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiDEHyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiDEHyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704C4201B7;
        Tue,  5 Apr 2022 00:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C188615C3;
        Tue,  5 Apr 2022 07:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1950BC340EE;
        Tue,  5 Apr 2022 07:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144975;
        bh=keUpYAHWoicj+Oo2gtADZIdAo5yx5AbK6F45brX3iyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYlMFBnxHSAXVqBBA8Cw6xvk4MZtFo5b7IJ6dgC/NpFQ+RNbB7Do92eNL9Pastlkk
         1/pQys9bpEm1j0fw+qgCxY+RK1k+Y3b1sS6kVz5YruoFCHZI6aYk1+Bcw+/zPhGvhn
         cjN8BKc7dH8YOrmbgYv5Q2w13TzFAwRlDZox9L3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0239/1126] PM: suspend: fix return value of __setup handler
Date:   Tue,  5 Apr 2022 09:16:26 +0200
Message-Id: <20220405070414.622948846@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 7a64ca17e4dd50d5f910769167f3553902777844 ]

If an invalid option is given for "test_suspend=<option>", the entire
string is added to init's environment, so return 1 instead of 0 from
the __setup handler.

  Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc5
    test_suspend=invalid"

and

 Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     test_suspend=invalid

Fixes: 2ce986892faf ("PM / sleep: Enhance test_suspend option with repeat capability")
Fixes: 27ddcc6596e5 ("PM / sleep: Add state field to pm_states[] entries")
Fixes: a9d7052363a6 ("PM: Separate suspend to RAM functionality from core")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/suspend_test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/power/suspend_test.c b/kernel/power/suspend_test.c
index d20526c5be15..b663a97f5867 100644
--- a/kernel/power/suspend_test.c
+++ b/kernel/power/suspend_test.c
@@ -157,22 +157,22 @@ static int __init setup_test_suspend(char *value)
 	value++;
 	suspend_type = strsep(&value, ",");
 	if (!suspend_type)
-		return 0;
+		return 1;
 
 	repeat = strsep(&value, ",");
 	if (repeat) {
 		if (kstrtou32(repeat, 0, &test_repeat_count_max))
-			return 0;
+			return 1;
 	}
 
 	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
 		if (!strcmp(pm_labels[i], suspend_type)) {
 			test_state_label = pm_labels[i];
-			return 0;
+			return 1;
 		}
 
 	printk(warn_bad_state, suspend_type);
-	return 0;
+	return 1;
 }
 __setup("test_suspend", setup_test_suspend);
 
-- 
2.34.1



