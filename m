Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E1A540AD1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351542AbiFGSYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352497AbiFGSVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:21:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA11239832;
        Tue,  7 Jun 2022 10:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE990B82367;
        Tue,  7 Jun 2022 17:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0829C341C8;
        Tue,  7 Jun 2022 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624416;
        bh=/iUON9WW6bsYbfVqaGxLRyqJA2zgabLnd46UiDlgoD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge/AWhTqcshdGP1srRsiES0+3M9jsITNsil1CZaU7yiXRA7ou8RfUPZe4EEpC4wkU
         VFzjrNxBiK6mCOyLJa/yxQr51v3nfN8VUPHJptrj25Gl4o6jre2eMMQoaqZ14X4pAg
         AhxUmdSaVHbrNgPK11G7DGQwOG56xCNpCSRh4AnEy47Enx670nY1j2+8E339gST28p
         gN8yx4IccchtrSolgjsqKTwFabTg1FBdWZofMTvjJ7hJagTcF2eKDhPsptd03jC4v/
         +JAdubpkm7lc2z3CbOiP/xa3J7ukVDteHo6v88fi2VP3akl89noErVkYo43htsCHxk
         49pd92h+LUi+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Ni <nizhen@uniontech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, ok@artecdesign.ee,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 12/60] USB: host: isp116x: check return value after calling platform_get_resource()
Date:   Tue,  7 Jun 2022 13:52:09 -0400
Message-Id: <20220607175259.478835-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Zhen Ni <nizhen@uniontech.com>

[ Upstream commit 134a3408c2d3f7e23eb0e4556e0a2d9f36c2614e ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Zhen Ni <nizhen@uniontech.com>
Link: https://lore.kernel.org/r/20220302033716.31272-1-nizhen@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/isp116x-hcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 8835f6bd528e..8c7f0991c21b 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1541,10 +1541,12 @@ static int isp116x_remove(struct platform_device *pdev)
 
 	iounmap(isp116x->data_reg);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(res->start, 2);
+	if (res)
+		release_mem_region(res->start, 2);
 	iounmap(isp116x->addr_reg);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, 2);
+	if (res)
+		release_mem_region(res->start, 2);
 
 	usb_put_hcd(hcd);
 	return 0;
-- 
2.35.1

