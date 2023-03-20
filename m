Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0EE6C080A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjCTBEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjCTBDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:03:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351AB2387C;
        Sun, 19 Mar 2023 17:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7F44611DD;
        Mon, 20 Mar 2023 00:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15650C4339B;
        Mon, 20 Mar 2023 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273844;
        bh=Yt/Y4InbJXB/dcW50V/+nvogfpabyCT8tsB0eJ+YHe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAsvSYPkNUXyZKcfvNNfMDdXpw356tGMBUl3J1VeaUZjep91g/b/eGlS+oOnV5hqP
         RGzI8B7JqCcy5n8by51laDDvAk0lFWySl7GmXVN2f8b9eWsBtBXGRB+lC3nMyvBHDi
         dxWD822p0GT9GpL138hW09L0X2NdfD/e0zOraiF5tcp1sVn53Fz74qv+AWpGDeruoU
         U3zGDqtcNAv1gmZlSDZNEh2ZdrJc2xAxecV8gF27M21Tgyxt6Xm29E8vtP/w9B6XHm
         rTjDIMqJuOUL6mNb5SeBeHuAXbMJKHh06BG9/nQiHnvLPgh5QnB1b12G8fhINsUCGo
         zQP/odDs09wDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrien Thierry <athierry@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, avri.altman@wdc.com,
        keosung.park@samsung.com, kwmad.kim@samsung.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/9] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date:   Sun, 19 Mar 2023 20:57:04 -0400
Message-Id: <20230320005707.1429405-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005707.1429405-1-sashal@kernel.org>
References: <20230320005707.1429405-1-sashal@kernel.org>
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
index abc156cf05f60..b45cd6c98bad7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8228,5 +8228,6 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
2.39.2

