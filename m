Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56236AA27C
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjCCVsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjCCVra (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:47:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D05564244;
        Fri,  3 Mar 2023 13:44:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED36461950;
        Fri,  3 Mar 2023 21:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B410C4339B;
        Fri,  3 Mar 2023 21:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879897;
        bh=F9liIfmRQVktoAn8wyKTNdmFd0qpqDIml8xV+QZbMDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyVa9upww0GEiSqiSnhnz0KUCuCOpX6QjbF+XX+ZhfHB+ArDSGWNBHaAoW+kk28uy
         iltO2d8DD97nXOtBUZfRmg+Jj+06EPS1ILMKGshOwDsn1JRdPdy9La5KY/TKwqmIHZ
         Q9xe+XZmGyvPp6Yd6/scdA6hbipRIEIxQFb3KjQ3kafbOyPow91Of8hk+cP+VkPUCJ
         govyjbyum+ddzzBxYqi3CVKmlg0pqo+Ma3EwOMFqXT6QR9630Sdtfx3IJuFSg+66Hm
         irt9kSiRiqJVM6lVatKz+32eP1dktfzXvEDBFPJaB9+QTRNcnW+y73YLaAaB1a8rBJ
         d1IQbicgiqrGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 48/60] drivers: base: component: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:43:02 -0500
Message-Id: <20230303214315.1447666-48-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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
index 5eadeac6c5322..7dbf14a1d9157 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -125,7 +125,7 @@ static void component_debugfs_add(struct aggregate_device *m)
 
 static void component_debugfs_del(struct aggregate_device *m)
 {
-	debugfs_remove(debugfs_lookup(dev_name(m->parent), component_debugfs_dir));
+	debugfs_lookup_and_remove(dev_name(m->parent), component_debugfs_dir);
 }
 
 #else
-- 
2.39.2

