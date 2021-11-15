Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F40450E4A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbhKOSOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240267AbhKOSH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE71161A56;
        Mon, 15 Nov 2021 17:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998256;
        bh=na57w2dP2cfj3PikNItjOG4dNB14fGncxyIEFPOun18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd4cxLgQpQx7vmV/4oZ1p9f9QxhTl78FjZ3RaFG0BuN12YoYx9gHG6caWovIBieLX
         QReaE9K2hvBth/inUYCJSnaTupb73fpZ2CaR7gblJH4FaJohWUflCDWVeq4Yz9yZ6E
         lpaK4bNYYbj8XS4WcGGOElGZ4rY+yQOTCm/upJi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/575] scsi: ufs: ufshcd-pltfrm: Fix memory leak due to probe defer
Date:   Mon, 15 Nov 2021 18:02:50 +0100
Message-Id: <20211115165359.142624325@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit b6ca770ae7f2c560a29bbd02c4e3d734fafaf804 ]

UFS drivers that probe defer will end up leaking memory allocated for clk
and regulator names via kstrdup() because the structure that is holding
this memory is allocated via devm_* variants which will be freed during
probe defer but the names are never freed.

Use same devm_* variant of kstrdup to free the memory allocated to name
when driver probe defers.

Kmemleak found around 11 leaks on Qualcomm Dragon Board RB5:

unreferenced object 0xffff66f243fb2c00 (size 128):
  comm "kworker/u16:0", pid 7, jiffies 4294893319 (age 94.848s)
  hex dump (first 32 bytes):
    63 6f 72 65 5f 63 6c 6b 00 76 69 72 74 75 61 6c  core_clk.virtual
    2f 77 6f 72 6b 71 75 65 75 65 2f 73 63 73 69 5f  /workqueue/scsi_
  backtrace:
    [<000000006f788cd1>] slab_post_alloc_hook+0x88/0x410
    [<00000000cfd1372b>] __kmalloc_track_caller+0x138/0x230
    [<00000000a92ab17b>] kstrdup+0xb0/0x110
    [<0000000037263ab6>] ufshcd_pltfrm_init+0x1a8/0x500
    [<00000000a20a5caa>] ufs_qcom_probe+0x20/0x58
    [<00000000a5e43067>] platform_probe+0x6c/0x118
    [<00000000ef686e3f>] really_probe+0xc4/0x330
    [<000000005b18792c>] __driver_probe_device+0x88/0x118
    [<00000000a5d295e8>] driver_probe_device+0x44/0x158
    [<000000007e83f58d>] __device_attach_driver+0xb4/0x128
    [<000000004bfa4470>] bus_for_each_drv+0x68/0xd0
    [<00000000b89a83bc>] __device_attach+0xec/0x170
    [<00000000ada2beea>] device_initial_probe+0x14/0x20
    [<0000000079921612>] bus_probe_device+0x9c/0xa8
    [<00000000d268bf7c>] deferred_probe_work_func+0x90/0xd0
    [<000000009ef64bfa>] process_one_work+0x29c/0x788
unreferenced object 0xffff66f243fb2c80 (size 128):
  comm "kworker/u16:0", pid 7, jiffies 4294893319 (age 94.848s)
  hex dump (first 32 bytes):
    62 75 73 5f 61 67 67 72 5f 63 6c 6b 00 00 00 00  bus_aggr_clk....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

With this patch no memory leaks are reported.

Link: https://lore.kernel.org/r/20210914092214.6468-1-srinivas.kandagatla@linaro.org
Fixes: aa4976130934 ("ufs: Add regulator enable support")
Fixes: c6e79dacd86f ("ufs: Add clock initialization support")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 68ce209577eca..8c92d1bde64be 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -91,7 +91,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
-		clki->name = kstrdup(name, GFP_KERNEL);
+		clki->name = devm_kstrdup(dev, name, GFP_KERNEL);
 		if (!strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
@@ -127,7 +127,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	if (!vreg)
 		return -ENOMEM;
 
-	vreg->name = kstrdup(name, GFP_KERNEL);
+	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
-- 
2.33.0



