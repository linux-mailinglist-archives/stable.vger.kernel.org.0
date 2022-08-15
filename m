Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC5594203
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240251AbiHOVCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242376AbiHOU7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:59:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EB7501B3;
        Mon, 15 Aug 2022 12:12:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74412B81106;
        Mon, 15 Aug 2022 19:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA563C433D7;
        Mon, 15 Aug 2022 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590774;
        bh=3ZYxbQiv8c/G+ELwnuTgMqLcylJFVaNM0i2o3i5VtNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQZx5fTYoi0YPlXRjMuHUWAsIULJGyizNCTl5XbXKxnEXwvbFICvPjnZg9wK0JDFr
         NufPvLwXQZms0BSyR2aNZtIOgngZMS892ZXxXEfsoWRaRKf5d0aITJFgHxRT6b3FRT
         bbZBjWOzdsIlxwBQI494bpv0y8ehnS9DAzAUDItw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Staudt <max@enpas.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0336/1095] can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback
Date:   Mon, 15 Aug 2022 19:55:35 +0200
Message-Id: <20220815180443.704217883@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 7e193a42c37cf40eba8ac5af2d5e8eeb8b9506f9 ]

Usually CAN devices support configurable bit rates. The limits are
defined by struct can_priv::bittiming_const. Another way is to
implement the struct can_priv::do_set_bittiming callback.

If the bit rate is configured via netlink, the can_changelink()
function checks that either can_priv::bittiming_const or struct
can_priv::do_set_bittiming is implemented.

In commit 431af779256c ("can: dev: add CAN interface API for fixed
bitrates") an API for configuring bit rates on CAN interfaces that
only support fixed bit rates was added. The supported bit rates are
defined by struct can_priv::bitrate_const.

However the above mentioned commit forgot to add the struct
can_priv::bitrate_const to the check in can_changelink().

In order to avoid to implement a no-op can_priv::do_set_bittiming
callback on devices with fixed bit rates, extend the check in
can_changelink() accordingly.

Link: https://lore.kernel.org/all/20220611144248.3924903-1-mkl@pengutronix.de
Fixes: 431af779256c ("can: dev: add CAN interface API for fixed bitrates")
Reported-by: Max Staudt <max@enpas.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 7633d98e3912..667ddd28fcdc 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -176,7 +176,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		 * directly via do_set_bitrate(). Bail out if neither
 		 * is given.
 		 */
-		if (!priv->bittiming_const && !priv->do_set_bittiming)
+		if (!priv->bittiming_const && !priv->do_set_bittiming &&
+		    !priv->bitrate_const)
 			return -EOPNOTSUPP;
 
 		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
-- 
2.35.1



