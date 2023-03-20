Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DB56C0899
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCTBgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjCTBgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:36:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B44241ED;
        Sun, 19 Mar 2023 18:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2671CE1037;
        Mon, 20 Mar 2023 00:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09313C433D2;
        Mon, 20 Mar 2023 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273782;
        bh=n0lxD0L/T/xjNVlKjGvIwM+TJoX1yR+9PzsF+/rIxWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czVkSFoIsBLbqyyPaIntmoRDXgmphEOxc/mq70vnwtn9k4lfFCSTz5XvNvSu1PZtw
         B4wiSlfNtDevazR1f44PZjVye4y3tvC4Dhy9pdZIRAFf3rZ8v6p64roM+uXMwowUna
         cRWkKXwa1Sm6oh1+dpAeJNISKf2EnxlyCT9zj8pN5w5bYcDyvTgsHQ2Yngj1ZF37Pd
         WK0JzB63io+ySdfLSnCIy4KSp9+5KMVH29X7a9Mqfg4GTr5qJSfxwElQ/aWk441I6N
         kwDQ9lWv0BfXXtFUaoW84Wt+EbjE19Fzi9gqWIk6suEvmsin2D5VWfUoayu3crwYii
         H4pgthQBs1Pkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrien Thierry <athierry@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        beanhuo@micron.com, bvanassche@acm.org, avri.altman@wdc.com,
        keosung.park@samsung.com, kwmad.kim@samsung.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/15] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date:   Sun, 19 Mar 2023 20:55:53 -0400
Message-Id: <20230320005559.1429040-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005559.1429040-1-sashal@kernel.org>
References: <20230320005559.1429040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrien Thierry <athierry@redhat.com>

[ Upstream commit 2ebe16155dc8bd4e602cad5b5f65458d2eaa1a75 ]

The ufshcd driver uses simpleondemand governor for devfreq. Add it to the
list of ufshcd softdeps to allow userspace initramfs tools like dracut to
automatically pull the governor module into the initramfs together with UFS
drivers.

Link: https://lore.kernel.org/r/20230220140740.14379-1-athierry@redhat.com
Signed-off-by: Adrien Thierry <athierry@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ea6ceab1a1b25..f3389e9131794 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9311,5 +9311,6 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
2.39.2

