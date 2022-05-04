Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8EA51A78C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355271AbiEDRGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356386AbiEDRFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA5250E07;
        Wed,  4 May 2022 09:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FFE8617A6;
        Wed,  4 May 2022 16:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D889C385A5;
        Wed,  4 May 2022 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683242;
        bh=bpjUbE/Xn+hEI8S5xOfpY2zy1g5hUwfAs4TcqRSWHuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzwZQtSKUZzvTGYYUAnbgLa21HR/qEA10fHS0cxEL/U+L8lAUyMGrLbZ+gBf1+gi6
         dZuTTGJ8v50Vvp0CaoHMb2ShiLsGaeiArV2kv/zzHP/9CshkFKtTA4SZlazFNmaCTd
         mrrYU2TxIFdPFkCQ17r88/mJ27caUVqwvgYSXqe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch.siach@siklu.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/177] net: phy: marvell10g: fix return value on error
Date:   Wed,  4 May 2022 18:45:00 +0200
Message-Id: <20220504153102.805435201@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

[ Upstream commit 0ed9704b660b259b54743cad8a84a11148f60f0a ]

Return back the error value that we get from phy_read_mmd().

Fixes: c84786fa8f91 ("net: phy: marvell10g: read copper results from CSSR1")
Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index bd310e8d5e43..df33637c5269 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -789,7 +789,7 @@ static int mv3310_read_status_copper(struct phy_device *phydev)
 
 	cssr1 = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_CSSR1);
 	if (cssr1 < 0)
-		return val;
+		return cssr1;
 
 	/* If the link settings are not resolved, mark the link down */
 	if (!(cssr1 & MV_PCS_CSSR1_RESOLVED)) {
-- 
2.35.1



