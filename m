Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8066AA4EA
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjCCWzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbjCCWyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:54:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDDE13DE0;
        Fri,  3 Mar 2023 14:54:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C37A1B819FF;
        Fri,  3 Mar 2023 21:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AB3C4339E;
        Fri,  3 Mar 2023 21:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880023;
        bh=eDAbc3E6vkdgLOC/lAHkOAJXOTSFc+gEsq8tg4WoIIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJ0GWRyKzdlcIisSMk8WG+YtkI/+ylJF7YNwdsEIYz9XyW698Kn5FaWYrCxiYAeq9
         t6e8+FPCM4yT+rFlbIeBl7tjKE3+bd084bPZEnb71cR9ISy2w/G+EJ3e9eZ0jGNgxe
         cKjmNQL1nZp8bCRd6/Gwg9wbzD91XJ4VRaEW17saHop7jqn97fE/ITCaYQZUUKreCu
         31ILsRgy7skPXCNaDMkFSDFSnQBNk+rgehSjwV4tykiYEQUUSQ9+8J9haEk3Sv93wZ
         8FM+ZzJ6dimu0bMJBNJEo8z1g/lDciT3QcShMtbnIQou/KHjzHUaiFEmaXl/6Xw03e
         jIhRmdAfT+A5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.15 43/50] kernel/time/test_udelay.c: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:24 -0500
Message-Id: <20230303214531.1450154-43-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
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

