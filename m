Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2156AA3D7
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbjCCWI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbjCCWIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:08:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16CA64238;
        Fri,  3 Mar 2023 13:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2971F6191C;
        Fri,  3 Mar 2023 21:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191EFC4339B;
        Fri,  3 Mar 2023 21:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879774;
        bh=eDAbc3E6vkdgLOC/lAHkOAJXOTSFc+gEsq8tg4WoIIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRvhIqq4uxIpC5SaIqu9Mp6L4+39vdeIQ97p5cJHYT2x8Xijli21y9OaoXXpHvk07
         baA6IjQ+4S0DJQFHLQTJW/qVAM7EOYmPV2KIa5M8zpNc8zpvEDtZkj0cOKvwaJ0JqS
         GY6fxHHMOjpD9o2N/qJbNqQVd3/Cv8Sm/iayo+lwZ/x9mnWkxPtOhDta4BkUjLsoKf
         2UvwvTMwMRuwpO9ubeKVTDzoUKx75zW3/QP1EDq7zO5EAszKZXDX35U9nVZl4BaHNR
         O5mJB8Y4AP4iKMCcBEuqVM2Z1lkYjUKfUWe3NNt0smdHlnFgchP+Pqw/f7ahdICwyg
         eynOel7q4SV/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de
Subject: [PATCH AUTOSEL 6.2 54/64] kernel/time/test_udelay.c: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:40:56 -0500
Message-Id: <20230303214106.1446460-54-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
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

[ Upstream commit 5f5139974c2030e0937d3ae01f17da1238281f11 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Link: https://lore.kernel.org/r/20230202151214.2306822-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.39.2

