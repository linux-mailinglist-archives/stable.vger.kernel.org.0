Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D87C658275
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiL1QgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiL1QfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:35:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09F7B30
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 752B9B81886
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC799C433D2;
        Wed, 28 Dec 2022 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245138;
        bh=BYzoasE212pm1jEdZFdR5TkfaiVtBZPaDqHRXUUl3UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKtnukw8ZcGcSAWN6T54lmwRBfvGXcmCTFGJPPXhLuy31xQ3pFF0el1HqLPN3PQS0
         RigEUaaybJckvCa2/qKSNOFr6wIDKPVdm/onNoRCopg4accfdlPRzbKsfv9zf5QFvj
         85oNdvaLnlIgvVpq324he3OdshC2B10lVCJDGOxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0839/1073] bonding: add missed __rcu annotation for curr_active_slave
Date:   Wed, 28 Dec 2022 15:40:27 +0100
Message-Id: <20221228144350.809571963@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3d0b738fc5adf9f380702ac1424672e4b32c3781 ]

There is one direct accesses to bond->curr_active_slave in
bond_miimon_commit(). Protected it by rcu_access_pointer()
since the later of this function also use this one.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e95cc44763a4 ("bonding: do failover when high prio link up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 445c23e424f7..36a8db140388 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2698,7 +2698,7 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!bond->curr_active_slave || slave == primary)
+			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary)
 				goto do_failover;
 
 			continue;
-- 
2.35.1



