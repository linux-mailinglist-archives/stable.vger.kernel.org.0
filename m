Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AE0548BAB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349317AbiFMK5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350249AbiFMKyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11428E024;
        Mon, 13 Jun 2022 03:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1628B80E5E;
        Mon, 13 Jun 2022 10:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75A3C34114;
        Mon, 13 Jun 2022 10:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116234;
        bh=+/FYCLGsRVRHNZXvwv77uB0pWt/M78vjProgDG0PYuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lclvt3DoXn2kXyOdoQCXt657EGna8Kw5y8LMQa6d8zCrthQA3iq3zTkT2KHURiFvh
         hFh0yD7pn210BTuoN6p2LNrlE7glLXshfZUNAAoQ50RzbVX1CSit91cjQ5OjbLZUYQ
         b7kuTYICi7wD7VwqqeJ/k2wuAnulXkrZykvm2JIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/411] mlxsw: spectrum_dcb: Do not warn about priority changes
Date:   Mon, 13 Jun 2022 12:05:12 +0200
Message-Id: <20220613094929.681987818@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit b6b584562cbe7dc357083459d6dd5b171e12cadb ]

The idea behind the warnings is that the user would get warned in case when
more than one priority is configured for a given DSCP value on a netdevice.

The warning is currently wrong, because dcb_ieee_getapp_mask() returns
the first matching entry, not all of them, and the warning will then claim
that some priority is "current", when in fact it is not.

But more importantly, the warning is misleading in general. Consider the
following commands:

 # dcb app flush dev swp19 dscp-prio
 # dcb app add dev swp19 dscp-prio 24:3
 # dcb app replace dev swp19 dscp-prio 24:2

The last command will issue the following warning:

 mlxsw_spectrum3 0000:07:00.0 swp19: Ignoring new priority 2 for DSCP 24 in favor of current value of 3

The reason is that the "replace" command works by first adding the new
value, and then removing all old values. This is the only way to make the
replacement without causing the traffic to be prioritized to whatever the
chip defaults to. The warning is issued in response to adding the new
priority, and then no warning is shown when the old priority is removed.
The upshot is that the canonical way to change traffic prioritization
always produces a warning about ignoring the new priority, but what gets
configured is in fact what the user intended.

An option to just emit warning every time that the prioritization changes
just to make it clear that it happened is obviously unsatisfactory.

Therefore, in this patch, remove the warnings.

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 21296fa7f7fb..bf51ed94952c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -227,8 +227,6 @@ static int mlxsw_sp_dcbnl_ieee_setets(struct net_device *dev,
 static int mlxsw_sp_dcbnl_app_validate(struct net_device *dev,
 				       struct dcb_app *app)
 {
-	int prio;
-
 	if (app->priority >= IEEE_8021QAZ_MAX_TCS) {
 		netdev_err(dev, "APP entry with priority value %u is invalid\n",
 			   app->priority);
@@ -242,17 +240,6 @@ static int mlxsw_sp_dcbnl_app_validate(struct net_device *dev,
 				   app->protocol);
 			return -EINVAL;
 		}
-
-		/* Warn about any DSCP APP entries with the same PID. */
-		prio = fls(dcb_ieee_getapp_mask(dev, app));
-		if (prio--) {
-			if (prio < app->priority)
-				netdev_warn(dev, "Choosing priority %d for DSCP %d in favor of previously-active value of %d\n",
-					    app->priority, app->protocol, prio);
-			else if (prio > app->priority)
-				netdev_warn(dev, "Ignoring new priority %d for DSCP %d in favor of current value of %d\n",
-					    app->priority, app->protocol, prio);
-		}
 		break;
 
 	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
-- 
2.35.1



