Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E82F658338
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiL1Qo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiL1Qod (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369451CB14
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA698B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD0C433EF;
        Wed, 28 Dec 2022 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245609;
        bh=kjAbANO2oQ9HRWy1w5jZAbLseyqeRUG7KDXrkkxEhu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ced8PlZyLvnLq2xRaIFFsfJNiKq21JfF8Wvn7SEkI12IngK1LBsf0A6+YJ3x1ydvL
         kn5hN+o3tp1FGXDhIkntE75W9zm9PlYpw62hoGDb09Vp2JLgBaj2/rArKNju9YFZrN
         UyYexQsDDOY1BXmuwtUlgXN3fbzuKf2Y6yi7QvQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0889/1146] bonding: add missed __rcu annotation for curr_active_slave
Date:   Wed, 28 Dec 2022 15:40:28 +0100
Message-Id: <20221228144354.327608151@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 29d0a6493b1b..af35a46994cc 100644
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



