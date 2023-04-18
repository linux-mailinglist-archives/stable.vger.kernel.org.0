Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA816E623B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjDRMbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjDRMa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F45C14C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D5866313B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B831C433EF;
        Tue, 18 Apr 2023 12:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821016;
        bh=7RphOSHuIa0h8UnK5yx+P6qWuZ++X7WnH484yVYEaEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aM5PYZG5m5F8gMdagS/7CzpsZ9FA0lsbcoVrxUVxSxqCPcztS/Et7ljUBRwoZ7D3
         JTM8efD9JMR8yoxYv/s93yR/vbiF/X3+h739/4TPlPoRq7NEoA4YUP/iRPoLoPvtoD
         Qxrcy088h4sKASbWha+C6sZ163jenWzCHvXmxOGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Denis Plotnikov <den-plotnikov@yandex-team.ru>,
        Simon Horman <simon.horman@corigine.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 59/92] qlcnic: check pci_reset_function result
Date:   Tue, 18 Apr 2023 14:21:34 +0200
Message-Id: <20230418120306.912177134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Plotnikov <den-plotnikov@yandex-team.ru>

[ Upstream commit 7573099e10ca69c3be33995c1fcd0d241226816d ]

Static code analyzer complains to unchecked return value.
The result of pci_reset_function() is unchecked.
Despite, the issue is on the FLR supported code path and in that
case reset can be done with pcie_flr(), the patch uses less invasive
approach by adding the result check of pci_reset_function().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7e2cf4feba05 ("qlcnic: change driver hardware interface mechanism")
Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
index af38d3d73291c..4814046cfc78e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -629,7 +629,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
 	int i, err, ring;
 
 	if (dev->flags & QLCNIC_NEED_FLR) {
-		pci_reset_function(dev->pdev);
+		err = pci_reset_function(dev->pdev);
+		if (err) {
+			dev_err(&dev->pdev->dev,
+				"Adapter reset failed (%d). Please reboot\n",
+				err);
+			return err;
+		}
 		dev->flags &= ~QLCNIC_NEED_FLR;
 	}
 
-- 
2.39.2



