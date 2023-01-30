Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FF868126C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbjA3OVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237626AbjA3OUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:20:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE722F799
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:19:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D709F6114B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB50EC433EF;
        Mon, 30 Jan 2023 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088337;
        bh=U9XON/C8fxo1adNsTmjrtZPSrMevWARLghlFaXiDdZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOAJ/Y8Sb8ix7Opfa3Tqplbr2JMkpu1QWyoDMtCUx+uWt7u3X67YpfmtFUbkMlLvL
         C3mBxZK2yxLMSEPaR1z7iea3Js9u3FOHdOcxSOaCqeJix1spbOHRH6jBC/EOFNR1S1
         JTk2JhvziNKBWJ+axlAgQnutuF+YYBCShwMq/fc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/204] net: ravb: Fix possible hang if RIS2_QFF1 happen
Date:   Mon, 30 Jan 2023 14:52:35 +0100
Message-Id: <20230130134324.912739095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 046189507ec1..c6fe1cda7b88 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -792,14 +792,14 @@ static void ravb_error_interrupt(struct net_device *ndev)
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



