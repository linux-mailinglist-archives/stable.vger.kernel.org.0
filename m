Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3248F119B22
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfLJWFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbfLJWFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:05:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE132053B;
        Tue, 10 Dec 2019 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015517;
        bh=CgxRm216WmCX4Q2oMM5pdlUpclSLBREMLbPFvNdU3nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxCSIY2NmxwxF/omFXewYyOIdrxefX+fVX8wicaDLvKzvY04juEBwH68RPqYV/oTQ
         1rzUzFoiSiraxWiHNJAgy3lVzYEnMK5FgoqoYwhYi0f9byFUwFuzpetPP23UeRVQqz
         lGS234HsnHK2dG0scyGxJT98rB1wynsnTcgcCZgQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Harish Jenny K N <harish_kandiga@mentor.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 114/130] mmc: tmio: Add MMC_CAP_ERASE to allow erase/discard/trim requests
Date:   Tue, 10 Dec 2019 17:02:45 -0500
Message-Id: <20191210220301.13262-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

[ Upstream commit c91843463e9e821dc3b48fe37e3155fa38299f6e ]

Isolated initially to renesas_sdhi_internal_dmac [1], Ulf suggested
adding MMC_CAP_ERASE to the TMIO mmc core:

On Fri, Nov 15, 2019 at 10:27:25AM +0100, Ulf Hansson wrote:
 -- snip --
 This test and due to the discussions with Wolfram and you in this
 thread, I would actually suggest that you enable MMC_CAP_ERASE for all
 tmio variants, rather than just for this particular one.

 In other words, set the cap in tmio_mmc_host_probe() should be fine,
 as it seems none of the tmio variants supports HW busy detection at
 this point.
 -- snip --

Testing on R-Car H3ULCB-KF doesn't reveal any issues (v5.4-rc7):

root@rcar-gen3:~# lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
mmcblk0      179:0    0 59.2G  0 disk  <--- eMMC
mmcblk0boot0 179:8    0    4M  1 disk
mmcblk0boot1 179:16   0    4M  1 disk
mmcblk1      179:24   0   30G  0 disk  <--- SD card

root@rcar-gen3:~# time blkdiscard /dev/mmcblk0
real    0m8.659s
user    0m0.001s
sys     0m1.920s

root@rcar-gen3:~# time blkdiscard /dev/mmcblk1
real    0m1.176s
user    0m0.001s
sys     0m0.124s

[1] https://lore.kernel.org/linux-renesas-soc/20191112134808.23546-1-erosca@de.adit-jv.com/

Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Originally-by: Harish Jenny K N <harish_kandiga@mentor.com>
Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index 2fd862dc97701..a09aad9155a56 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -1220,7 +1220,7 @@ int tmio_mmc_host_probe(struct tmio_mmc_host *_host,
 		_host->start_signal_voltage_switch;
 	mmc->ops = &tmio_mmc_ops;
 
-	mmc->caps |= MMC_CAP_4_BIT_DATA | pdata->capabilities;
+	mmc->caps |= MMC_CAP_ERASE | MMC_CAP_4_BIT_DATA | pdata->capabilities;
 	mmc->caps2 |= pdata->capabilities2;
 	mmc->max_segs = pdata->max_segs ? : 32;
 	mmc->max_blk_size = 512;
-- 
2.20.1

