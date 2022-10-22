Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F0A60871C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiJVH4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiJVHyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A472CDE7;
        Sat, 22 Oct 2022 00:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1158B82E13;
        Sat, 22 Oct 2022 07:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF63C433C1;
        Sat, 22 Oct 2022 07:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424827;
        bh=qubxgJW3yy4v52tdRBQ7C/fWqSRTYb6tebZiHAJIdL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gR/r/+dCvEDeH7zXQm3r1qOKh7VlWIV2G9w53qf87qC4Z3xPEfGj1xbi7mWqes1Il
         nOSayFLQb3l1ThmkzyVVDVreo+H5xtPP54sPJ0+vObtJwqSQ6JOeM5fDijXIisroyh
         9ohnL5Fjht0obMx/6fjVBf+u0ZVkvWRW3MutUx40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Wang <zyytlz.wz@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 290/717] eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address
Date:   Sat, 22 Oct 2022 09:22:49 +0200
Message-Id: <20221022072504.730256985@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 12aece8b01507a2d357a1861f470e83621fbb6f2 ]

This frees "mac" and tries to display its address as part of the error
message on the next line.  Swap the order.

Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 3773ce5e12cc..37711331ba0f 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -248,8 +248,8 @@ static int spl2sw_nvmem_get_mac_address(struct device *dev, struct device_node *
 
 	/* Check if mac address is valid */
 	if (!is_valid_ether_addr(mac)) {
-		kfree(mac);
 		dev_info(dev, "Invalid mac address in nvmem (%pM)!\n", mac);
+		kfree(mac);
 		return -EINVAL;
 	}
 
-- 
2.35.1



