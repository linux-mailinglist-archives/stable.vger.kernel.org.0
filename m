Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D039603D85
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJSJDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiJSJCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A828B97EF7;
        Wed, 19 Oct 2022 01:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C701361802;
        Wed, 19 Oct 2022 08:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63ADC433D6;
        Wed, 19 Oct 2022 08:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169682;
        bh=XvxXrB03lskT/0SF6VJa6ZjRDrEAMuxJWTrz1oa5Eus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9inPIEvlWkd2snhcKavQ8FFC3GyVTz2kWjmAQ15kYE0KPSRGGGH56xRwo1Y30/1z
         mZjwsjvfaafKz1g+6rsOlMTpHwP4xo+EFsrpUqzUCRYE5jo+rLwfHqyqX2SuPTbX3l
         G/RasUMEvAVcU5wZYiAj7tDlpVyFXnaR3hZhxwak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Wang <zyytlz.wz@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 341/862] eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address
Date:   Wed, 19 Oct 2022 10:27:08 +0200
Message-Id: <20221019083305.132887688@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 546206640492..61d1d07dc070 100644
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



