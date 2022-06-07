Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7019F540E1A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353610AbiFGSwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354631AbiFGSrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EEB50E31;
        Tue,  7 Jun 2022 11:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7E7FB81F38;
        Tue,  7 Jun 2022 18:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FE5C385A5;
        Tue,  7 Jun 2022 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624960;
        bh=vYzLSmQkbnTtiS//7dQpP11ufnfqxIvecp/s4C8a2C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npUgRiVuiuXboRS8cBzUHTPkgx/ILXS+pGfsRzli+WeoEekh0uYyjkZ07UaQMMgee
         kxrYiLJxN58IIwY5gNmuXrJ72I2g8m6v9PlQafKTqiLqK6BGzQCvrUl3Vngj3DoRpp
         yFgZWRMVwYsP3yPdCtuM8E5ugRBfujWR9ndr/hG5k2AmGNvwE2N2ec8aYRdIhAuq18
         Tc5lB9Xjr6F6Mjg0dBZk5OMHiojOdhXS+WqxIVroDcNBC/Dl6l5uWbSP0c0aSjAxZY
         OLXs5e6PH+PFWJgFTpDr8u5J65l6JWQ/P3bzDGlurNm5M/mdPJM/r/95hYlEp5ax67
         tZvViv9UEOfgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Ni <nizhen@uniontech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, ok@artecdesign.ee,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/25] USB: host: isp116x: check return value after calling platform_get_resource()
Date:   Tue,  7 Jun 2022 14:02:07 -0400
Message-Id: <20220607180229.482040-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180229.482040-1-sashal@kernel.org>
References: <20220607180229.482040-1-sashal@kernel.org>
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
index 73fec38754f9..83eb62001679 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1551,10 +1551,12 @@ static int isp116x_remove(struct platform_device *pdev)
 
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

