Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2236AA2C1
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjCCVvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjCCVux (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:50:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3CF6C1BF;
        Fri,  3 Mar 2023 13:47:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6489A61956;
        Fri,  3 Mar 2023 21:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B584CC433A4;
        Fri,  3 Mar 2023 21:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880020;
        bh=jPjRG8J2Lw/T6MTjpltlKQ/ub2il2H98DaZwP94Z7O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFSgEod2DDq7YoZsu4uo3yoAAZOim9Kn4mU9gEq5gJ84cVV/oQ29vE1mXXHmfhXd3
         M800dJgnBQSJjlh3nkljY1ycjoNtghx0rWO+uHNDZQjauAxep7PyiCJ1413e6UHD5l
         sJebsqPFwO2VPKv8H7tK2uYUrTS4vc7BiFQfsppbSrhiWDFn+8qJoJQIk9MNqzC3Xg
         +V/2viAY0c046xaErnLvALNJ52Fae/bJ00THqrgFLmp6XJSg9FJeKykF80rNTdACax
         A0m6pTrhVngxjp6et00eLG+hz4k0EI5q7hUELD/ZzcGrpRd74eBoPoY2AXYDmr0/yU
         OHHWU1pj9fSCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 42/50] drivers: base: dd: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:23 -0500
Message-Id: <20230303214531.1450154-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
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

[ Upstream commit 36c893d3a759ae7c91ee7d4871ebfc7504f08c40 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230202141621.2296458-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 060348125635b..9cbf086fe5524 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -352,7 +352,7 @@ late_initcall(deferred_probe_initcall);
 
 static void __exit deferred_probe_exit(void)
 {
-	debugfs_remove_recursive(debugfs_lookup("devices_deferred", NULL));
+	debugfs_lookup_and_remove("devices_deferred", NULL);
 }
 __exitcall(deferred_probe_exit);
 
-- 
2.39.2

