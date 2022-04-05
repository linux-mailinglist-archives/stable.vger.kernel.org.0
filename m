Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F474F2D4E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348026AbiDEJ3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245048AbiDEIxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAB0EB7;
        Tue,  5 Apr 2022 01:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD7A8614FD;
        Tue,  5 Apr 2022 08:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CDBC385A0;
        Tue,  5 Apr 2022 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148635;
        bh=MWm4SF4vTdAg8YYiuLtbAmzMG7TK3H/DsZTmry+1Ino=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdGfUkZbAoFD19tb4uG5rskvkib+um/5np6zsoF1x3j940uvWTFxr2v4eMYukUYV+
         QdD3X6ZBL13x/fm9PwIubMYgP44395RFcXmHU7ZNhwQv+YQKe3MvJrcbRe4Nv19OIm
         xzHXb5NLWl5IsJJdF/LX/Pr5u7uVLg5xb88GUlEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0424/1017] ionic: start watchdog after all is setup
Date:   Tue,  5 Apr 2022 09:22:17 +0200
Message-Id: <20220405070406.876141352@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 9ad2939a1525962a79a2fd974ec7e3a71455b964 ]

The watchdog expects the lif to fully exist when it goes off,
so lets not start the watchdog until all is ready in case there
is some quirky time dialation that makes probe take multiple
seconds.

Fixes: 089406bc5ad6 ("ionic: add a watchdog timer to monitor heartbeat")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 4 +++-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 7e296fa71b36..40fa5bce2ac2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -331,6 +331,9 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_deregister_lifs;
 	}
 
+	mod_timer(&ionic->watchdog_timer,
+		  round_jiffies(jiffies + ionic->watchdog_period));
+
 	return 0;
 
 err_out_deregister_lifs:
@@ -348,7 +351,6 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_reset:
 	ionic_reset(ionic);
 err_out_teardown:
-	del_timer_sync(&ionic->watchdog_timer);
 	pci_clear_master(pdev);
 	/* Don't fail the probe for these errors, keep
 	 * the hw interface around for inspection
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index d57e80d44c9d..4044c630f8b4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -122,9 +122,6 @@ int ionic_dev_setup(struct ionic *ionic)
 	idev->fw_generation = IONIC_FW_STS_F_GENERATION &
 			      ioread8(&idev->dev_info_regs->fw_status);
 
-	mod_timer(&ionic->watchdog_timer,
-		  round_jiffies(jiffies + ionic->watchdog_period));
-
 	idev->db_pages = bar->vaddr;
 	idev->phy_db_pages = bar->bus_addr;
 
-- 
2.34.1



