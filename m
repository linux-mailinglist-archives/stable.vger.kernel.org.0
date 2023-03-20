Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D4D6C07AB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCTBAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjCTBAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3E716309;
        Sun, 19 Mar 2023 17:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E10CB80D4E;
        Mon, 20 Mar 2023 00:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05297C433D2;
        Mon, 20 Mar 2023 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273684;
        bh=uhpHKDtveePneae/gaCA0Ga6U86TYLBoLMxpJudowSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiYQs9e8ITRG3eRZ/FGXZz+u9wV2lNovlrgeyd+y/LqZzi+sZ6qIjo2vNpXIIKh00
         l2vn/IvVON0CAHAbWwjVo9MFkHnyDCuE4Q7wOVN/J1ZCqvJrr5Oqd02dKT3tLHzBvW
         bQgtNnyN0EwB7wLyc7Bth8SSM97yuedjg1OngofmbCahtIIKb9PxUqSpARfsN4ztg0
         NVmkZm7Gjn4ayYJjN+aAwyhEmWtd8elnmGem56yOwasBGR8rT3wO2YvW+EVZJC2c1Q
         jAqiuz3Vwe1oxMteo+fegRkvi9XErN4qtwSyG2rtcKs5CEW0WJOaqZkTPXleGorr4x
         i3BOnP/rivffA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrien Thierry <athierry@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, quic_asutoshd@quicinc.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 12/29] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date:   Sun, 19 Mar 2023 20:53:54 -0400
Message-Id: <20230320005413.1428452-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
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
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index edd34dac91b1d..d89ce7fb6b363 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10074,4 +10074,5 @@ module_exit(ufshcd_core_exit);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
-- 
2.39.2

