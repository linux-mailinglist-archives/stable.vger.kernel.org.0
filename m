Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB07E4B49F1
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344771AbiBNKEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:04:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344761AbiBNKEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:04:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CF943496;
        Mon, 14 Feb 2022 01:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D8E7B80D83;
        Mon, 14 Feb 2022 09:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7443AC340EF;
        Mon, 14 Feb 2022 09:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832130;
        bh=ZpMz6lI2fdG/Wzo5lXOmPabcTGrlBaNjRWX7oyNMaGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HR/4zn7Zg0pHVOSEqWYeMgX5KSLO/qxQ44X662cD5ca31JWyF4No/7Hh0WPo3A3Nw
         PssTq+JfF7sDZ4uEzQPWWkl0B5ErEahqzkWAeiacibV3/RU5EtYZy+tTOQsqC1nXI2
         V5EoIWHPp6gML5NM1+qM1VRkg5gTWCtxIsUqKTTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/172] phy: stm32: fix a refcount leak in stm32_usbphyc_pll_enable()
Date:   Mon, 14 Feb 2022 10:25:46 +0100
Message-Id: <20220214092509.450851928@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cfc826c88a79e22ba5d8001556eb2c7efd8a01b6 ]

This error path needs to decrement "usbphyc->n_pll_cons.counter" before
returning.

Fixes: 5b1af71280ab ("phy: stm32: rework PLL Lock detection")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220112111724.GB3019@kili
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/st/phy-stm32-usbphyc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 937a14fa7448a..da05642d3bd4a 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -225,7 +225,7 @@ static int stm32_usbphyc_pll_enable(struct stm32_usbphyc *usbphyc)
 
 		ret = __stm32_usbphyc_pll_disable(usbphyc);
 		if (ret)
-			return ret;
+			goto dec_n_pll_cons;
 	}
 
 	ret = stm32_usbphyc_regulators_enable(usbphyc);
-- 
2.34.1



