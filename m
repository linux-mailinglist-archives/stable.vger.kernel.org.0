Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EB34F318E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346796AbiDEJzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343893AbiDEJOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:14:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7DA546BD;
        Tue,  5 Apr 2022 02:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7683EB818F3;
        Tue,  5 Apr 2022 09:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6C2C385A1;
        Tue,  5 Apr 2022 09:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149275;
        bh=W7azgFtB3eoyPbKVCXYneVHCBwwIMZA4peV6ACtcEis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG1CeNHnLVcmuCoFRG8uAEpvcFGkmegC5AYOtDp30ogPRj+o6QLVTR6RpHTCzehcr
         bt44RoC8SemlfQa2DHDvr8hCurgT6r4xbl0JEzQfF6R7xIBrTL2YK9SJVeyAr1KbnA
         fENP1K0KgjRnnKhpxxdbncoz/qOHy6kNbXa/Kmos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0657/1017] staging: qlge: add unregister_netdev in qlge_probe
Date:   Tue,  5 Apr 2022 09:26:10 +0200
Message-Id: <20220405070413.785253661@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 4fcc0c275e3f59cd68f977c57953783f8014ed15 ]

unregister_netdev need to be called when register_netdev succeeds
qlge_health_create_reporters fails.

Fixes: d8827ae8e22b ("staging: qlge: deal with the case that devlink_health_reporter_create fails")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220221085552.93561-1-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/qlge/qlge_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 9873bb2a9ee4..113a3efd12e9 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4605,14 +4605,12 @@ static int qlge_probe(struct pci_dev *pdev,
 	err = register_netdev(ndev);
 	if (err) {
 		dev_err(&pdev->dev, "net device registration failed.\n");
-		qlge_release_all(pdev);
-		pci_disable_device(pdev);
-		goto netdev_free;
+		goto cleanup_pdev;
 	}
 
 	err = qlge_health_create_reporters(qdev);
 	if (err)
-		goto netdev_free;
+		goto unregister_netdev;
 
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
@@ -4626,6 +4624,11 @@ static int qlge_probe(struct pci_dev *pdev,
 	devlink_register(devlink);
 	return 0;
 
+unregister_netdev:
+	unregister_netdev(ndev);
+cleanup_pdev:
+	qlge_release_all(pdev);
+	pci_disable_device(pdev);
 netdev_free:
 	free_netdev(ndev);
 devlink_free:
-- 
2.34.1



