Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040375938B8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbiHOSrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244244AbiHOSqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:46:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5502E419B1;
        Mon, 15 Aug 2022 11:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9615EB81062;
        Mon, 15 Aug 2022 18:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37D1C433C1;
        Mon, 15 Aug 2022 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588099;
        bh=Qt1VPSwfEWzTtNanrkuYk5V/ufnsCNnE/v6Cq1OAj1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUxTcmDUyauRmu6OMpHKkREXwdLNbOZe3MGDernXtxc6DkSJ1n4nyrUjoY3l55mbe
         JN7HxLN/R16JcGEr8AMHzqSjLNZihqlbGqKQgl6UFsu46NfJeUOS6bfj4LQYj+8qcK
         Vou9Xk5QYQhtdLlo0E6o79bV37BkUsqDsHw0mWic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Staudt <max@enpas.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/779] can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback
Date:   Mon, 15 Aug 2022 19:58:27 +0200
Message-Id: <20220815180348.599658611@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit ec30c109391c5eac9b1d689a61e4bfed88148947 ]

This patch is similar to 7e193a42c37c ("can: netlink: allow
configuring of fixed bit rates without need for do_set_bittiming
callback") but for data bit rates instead of bit rates.

Usually CAN devices support configurable data bit rates. The limits
are defined by struct can_priv::data_bittiming_const. Another way is
to implement the struct can_priv::do_set_data_bittiming callback.

If the bit rate is configured via netlink, the can_changelink()
function checks that either can_priv::data_bittiming_const or struct
can_priv::do_set_data_bittiming is implemented.

In commit 431af779256c ("can: dev: add CAN interface API for fixed
bitrates") an API for configuring bit rates on CAN interfaces that
only support fixed bit rates was added. The supported bit rates are
defined by struct can_priv::bitrate_const.

However the above mentioned commit forgot to add the struct
can_priv::data_bitrate_const to the check in can_changelink().

In order to avoid to implement a no-op can_priv::do_set_data_bittiming
callback on devices with fixed data bit rates, extend the check in
can_changelink() accordingly.

Link: https://lore.kernel.org/all/20220613143633.4151884-1-mkl@pengutronix.de
Fixes: 431af779256c ("can: dev: add CAN interface API for fixed bitrates")
Acked-by: Max Staudt <max@enpas.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index cdde7fecefcf..29e2beae3357 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -170,7 +170,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		 * directly via do_set_bitrate(). Bail out if neither
 		 * is given.
 		 */
-		if (!priv->data_bittiming_const && !priv->do_set_data_bittiming)
+		if (!priv->data_bittiming_const && !priv->do_set_data_bittiming &&
+		    !priv->data_bitrate_const)
 			return -EOPNOTSUPP;
 
 		memcpy(&dbt, nla_data(data[IFLA_CAN_DATA_BITTIMING]),
-- 
2.35.1



