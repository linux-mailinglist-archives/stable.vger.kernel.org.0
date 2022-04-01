Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7444EF2E5
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347639AbiDAOwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349474AbiDAOqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:46:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F382D3B02C;
        Fri,  1 Apr 2022 07:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0694660B8C;
        Fri,  1 Apr 2022 14:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854A2C340F2;
        Fri,  1 Apr 2022 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823761;
        bh=f/A667sfGyypC0+NC/64NskgbJLS0OZMs3pxRLf7nJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYlMiZFpgYO9ZKB1g/HbUqKe8M8PGzrfXVgrMzyR/fod1PUmK5yuCWHbmERtkw48q
         serVyI0xrrOYVzaGsrD9vvFDj5oyCm55wTugsW13cGTGAE2RVnrf1KWkr80sK0HMGR
         fn3L9WT0e6dvhmfRtGI8chY57gkm3VahSKGJ46CDIXVYH1+krH18kPhg3badU8iquK
         37wEjtC+PfkqoSb0zZ8O/O0Q4PQzBh0AvL3k+fwYvAh4cBRh8ipJghUpKKdyx9ndkm
         pZGFePfvi6F71Zjdd6mDNNLGtX40jninenGboK6Lac0GHcb++0k6emojQaV+ihSvFj
         5UYNXjG9l0mcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 068/109] scsi: pm8001: Fix memory leak in pm8001_chip_fw_flash_update_req()
Date:   Fri,  1 Apr 2022 10:32:15 -0400
Message-Id: <20220401143256.1950537-68-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit f792a3629f4c4aa4c3703d66b43ce1edcc3ec09a ]

In pm8001_chip_fw_flash_update_build(), if
pm8001_chip_fw_flash_update_build() fails, the struct fw_control_ex
allocated must be freed.

Link: https://lore.kernel.org/r/20220220031810.738362-23-damien.lemoal@opensource.wdc.com
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 5325da0e35f7..e1f449dda40b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4904,8 +4904,10 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	ccb->ccb_tag = tag;
 	rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		pm8001_tag_free(pm8001_ha, tag);
+	}
 
 	return rc;
 }
-- 
2.34.1

