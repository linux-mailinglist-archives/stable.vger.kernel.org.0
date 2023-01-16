Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE02B66C52B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjAPQCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjAPQCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:02:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E985D23C70
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 956F4B81061
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BE5C433F0;
        Mon, 16 Jan 2023 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884911;
        bh=LhLcymre40N3ru1qokaMuvrTvAXrEyGWkscN6ZFbY2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhCyzKZisaQUxo5yCHI5SMsi35WymUmFS4U/DC5lZhWL3ZQCEn+ngWwwZjuPnmJ+g
         M/64QI2MmxkOipy/uVJ1dMoajj4AvcbQ4P6ZqKDBTb0nRQ04vFB+3GSd4yS4ZVwyAK
         cCtHnbdcik7QP06TDzh72nAzag7YrsGTuKN0NU6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/183] net: lan966x: check for ptp to be enabled in lan966x_ptp_deinit()
Date:   Mon, 16 Jan 2023 16:51:32 +0100
Message-Id: <20230116154810.433968281@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit b0e380b5d4275299adf43e249f18309331b6f54f ]

If ptp was not enabled due to missing IRQ for instance,
lan966x_ptp_deinit() will dereference NULL pointers.

Fixes: d096459494a8 ("net: lan966x: Add support for ptp clocks")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index e5a2bbe064f8..8e368318558a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -853,6 +853,9 @@ void lan966x_ptp_deinit(struct lan966x *lan966x)
 	struct lan966x_port *port;
 	int i;
 
+	if (!lan966x->ptp)
+		return;
+
 	for (i = 0; i < lan966x->num_phys_ports; i++) {
 		port = lan966x->ports[i];
 		if (!port)
-- 
2.35.1



