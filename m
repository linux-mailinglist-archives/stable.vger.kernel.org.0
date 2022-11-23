Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B079635848
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiKWJyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbiKWJxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:53:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB42F72FE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:49:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE74B61B60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFE9C433C1;
        Wed, 23 Nov 2022 09:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196973;
        bh=1Clm3qitxJwgixKfBTtLTIZPEEec+aL2nHPMWogARe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1crzY94AVxaBUXezxS5HCW1RfL/kEolMF3suhDLJEn3TryBT4/wZI67TGSxexqlY3
         xfWVrQ0CGJZRacWXjBCLbjop8CitNrwKLDf1aZHQ/SkROTf/5dW7PC9hL2tf/iSVRR
         dRtFzd7ugumPkzVHbf6MXzkXAxCPKrONJ0hm+wOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 162/314] octeon_ep: fix potential memory leak in octep_device_setup()
Date:   Wed, 23 Nov 2022 09:50:07 +0100
Message-Id: <20221123084632.918468160@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit e4041be97b15302ebfffda8bbd45f3b2d096048f ]

When occur unsupported_dev and mbox init errors, it did not free oct->conf
and iounmap() oct->mmio[i].hw_addr. That would trigger memory leak problem.
Add kfree() for oct->conf and iounmap() for oct->mmio[i].hw_addr under
unsupported_dev and mbox init errors to fix the problem.

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 92ca3e502465..ac1e37afbe7b 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -956,7 +956,7 @@ int octep_device_setup(struct octep_device *oct)
 	ret = octep_ctrl_mbox_init(ctrl_mbox);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
-		return -1;
+		goto unsupported_dev;
 	}
 	oct->ctrl_mbox_ifstats_offset = OCTEP_CTRL_MBOX_SZ(ctrl_mbox->h2fq.elem_sz,
 							   ctrl_mbox->h2fq.elem_cnt,
@@ -966,6 +966,10 @@ int octep_device_setup(struct octep_device *oct)
 	return 0;
 
 unsupported_dev:
+	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
+		iounmap(oct->mmio[i].hw_addr);
+
+	kfree(oct->conf);
 	return -1;
 }
 
-- 
2.35.1



