Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF066895D7
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjBCKUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjBCKUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:20:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2747B9EE21
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:20:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E88E61ECD
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029E2C4339E;
        Fri,  3 Feb 2023 10:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419594;
        bh=E7ILEv6xYLIze7BuDctwewhya2kxi7QeYBzfDzeccc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCxrAT5GQfiC1P5bHibB72g2Yq0l97nx1JK0kEbCnR3A6CVyo4KUDCL293YInKEzA
         Wk18MJ1MKOvCZ/Oc2osvit1ujkgT2p/u5j0/2pwLeC6g844lF5aAcZ6MaRuUkhNCxw
         vMaSl+ggek/OZufOT8cn2ITmLx1KsBSrD4sIDN5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/80] net: ravb: Fix possible hang if RIS2_QFF1 happen
Date:   Fri,  3 Feb 2023 11:12:49 +0100
Message-Id: <20230203101017.546752261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit f3c07758c9007a6bfff5290d9e19d3c41930c897 ]

Since this driver enables the interrupt by RIC2_QFE1, this driver
should clear the interrupt flag if it happens. Otherwise, the interrupt
causes to hang the system.

Note that this also fix a minor coding style (a comment indentation)
around the fixed code.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index ff374d0d80a7..a1906804c139 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -738,14 +738,14 @@ static void ravb_error_interrupt(struct net_device *ndev)
 	ravb_write(ndev, ~(EIS_QFS | EIS_RESERVED), EIS);
 	if (eis & EIS_QFS) {
 		ris2 = ravb_read(ndev, RIS2);
-		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_RFFF | RIS2_RESERVED),
+		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_QFF1 | RIS2_RFFF | RIS2_RESERVED),
 			   RIS2);
 
 		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF0)
 			priv->stats[RAVB_BE].rx_over_errors++;
 
-		    /* Receive Descriptor Empty int */
+		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF1)
 			priv->stats[RAVB_NC].rx_over_errors++;
 
-- 
2.39.0



