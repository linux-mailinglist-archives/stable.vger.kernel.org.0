Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF1F4A8D9A
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354070AbiBCUb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354229AbiBCUbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A28C0613E5;
        Thu,  3 Feb 2022 12:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39D6BB835A4;
        Thu,  3 Feb 2022 20:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19C0C340E8;
        Thu,  3 Feb 2022 20:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920261;
        bh=Y4I1XbzZkketrSB1+LOJA9GxTunIlw/Msl9gsyKUgh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyVxNekBCByjnqztyEEJrtkHz+l7kWg3RICfjXxAxjObjvyPZiU3yX3ucg1IOEBVO
         unbowsMJe+4edrIUBKtYz3cYvsTdTl68fdqbOvSHv81rGlXTfLu3qzC/yqG5KfK4LB
         CEfrP3hhaTK0CVZep4EUe6XtmM3Ab7cKLZ/zYhDiRuxx0Ti458n+EE+TH1hpYMXVJ1
         cCDtu+UpxqfetKWpxyGGgf+0I5wHQ9QVg1xS5S+kFyKLPdFXgAncVzrlGW0Lfcqd5p
         9PXnrtgJAL8vs35h97in1PG6ifglrR5Drj27LM4DBCYOvaoR0DnLaXZPcuui0qtzKq
         Jme6ER4D6A+3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, stanley.chu@mediatek.com,
        srinivas.kandagatla@linaro.org, s.shtylyov@omprussia.ru,
        huyue2@yulong.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 27/52] scsi: ufs: ufshcd-pltfrm: Check the return value of devm_kstrdup()
Date:   Thu,  3 Feb 2022 15:29:21 -0500
Message-Id: <20220203202947.2304-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit a65b32748f4566f986ba2495a8236c141fa42a26 ]

devm_kstrdup() returns pointer to allocated string on success, NULL on
failure. So it is better to check the return value of it.

Link: https://lore.kernel.org/r/tencent_4257E15D4A94FF9020DDCC4BB9B21C041408@qq.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8b16bbbcb806c..87975d1a21c8b 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -92,6 +92,11 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
 		clki->name = devm_kstrdup(dev, name, GFP_KERNEL);
+		if (!clki->name) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		if (!strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
@@ -127,6 +132,8 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		return -ENOMEM;
 
 	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!vreg->name)
+		return -ENOMEM;
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
-- 
2.34.1

