Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF8C6AA340
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbjCCV4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbjCCVy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:54:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8116547A;
        Fri,  3 Mar 2023 13:48:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652EA6192A;
        Fri,  3 Mar 2023 21:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA0AC4339E;
        Fri,  3 Mar 2023 21:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880019;
        bh=FsuHxiNnkMRJzz+GyhI0Wl6VftsEvMm5IV1r/r4jh5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NowPHOca/YHJgRb7t++Jw4Xeig/PBCBCLm4TSN9JfNigRmadxBKyTQhawfV6jWrH7
         U5W9Qw6tVas1C4KwduIUWhSxeQJHb5DGuRItjwTZFoMMYQcsHdpEy65a5ehVxmaQ/f
         TjSnouxXryiOurvuolCf4T4MhWI5kc0jCM7Q+FxZeali+980RiAlGtfTP+/fhng4MR
         DAFnSqK9k7a10G9LPXTdtt2P06OaVfwYz3YzMNRJfCG2bKU4hTryYMvWclTtUXo+tj
         +PnEG+bhgdRCWGJqwXdCesPSbDF3noEzgbQPzfjiDHwWgBq3nR8KlXaXBWnsoLKnkJ
         3NgOGtoBJKH7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 41/50] drivers: base: component: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:22 -0500
Message-Id: <20230303214531.1450154-41-sashal@kernel.org>
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
index 870485cbbb87c..058f1a2cb2a9a 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -130,7 +130,7 @@ static void component_master_debugfs_add(struct master *m)
 
 static void component_master_debugfs_del(struct master *m)
 {
-	debugfs_remove(debugfs_lookup(dev_name(m->parent), component_debugfs_dir));
+	debugfs_lookup_and_remove(dev_name(m->parent), component_debugfs_dir);
 }
 
 #else
-- 
2.39.2

