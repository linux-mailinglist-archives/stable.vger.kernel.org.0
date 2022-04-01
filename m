Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0964EF578
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355173AbiDAPOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349865AbiDAO6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F13216BCCF;
        Fri,  1 Apr 2022 07:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7612B8251E;
        Fri,  1 Apr 2022 14:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E0AC36AE5;
        Fri,  1 Apr 2022 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824019;
        bh=474dM7FGw0UjuPO4octXR2ErFhwhs+OfNX1MU3Q3rTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3Vy3uvrw91k1rtc9NH3oxs3kQnWH8FLLVopmmeEenj5n6Upy3/7O0g6dgBocIgTs
         4RwiB+bdqTnKrvd2PK9zrqljdkspKMoKEZOq6SNoaTX2NtfERni4Jw4DsNed5d39h4
         aY1eIK2OmR20SOgX00H2yJXa/GOXK0qDYk1ZSkgO96rUU1YUD0Lf6ALKgGF03rI65m
         ux6ycv2jJW+mNJeXc30L0oqqK9tfeGu4/V2LdVNECXIT06Ii3ucMh591IuORs5b2PX
         9R8rtfN7+6StCHRCp6gDowiSmgZrEiIfVzqieK4RXX5O9ip9cFnuCchTtc4dmtzLD+
         UYK6lnJgR7yMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 54/98] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
Date:   Fri,  1 Apr 2022 10:36:58 -0400
Message-Id: <20220401143742.1952163-54-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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

[ Upstream commit 7e6b7e740addcea450041b5be8e42f0a4ceece0f ]

The call to pm8001_ccb_task_free() at the end of
pm8001_mpi_task_abort_resp() already frees the ccb tag. So when the device
NCQ_ABORT_ALL_FLAG is set, the tag should not be freed again.  Also change
the hardcoded 0xBFFFFFFF value to ~NCQ_ABORT_ALL_FLAG as it ought to be.

Link: https://lore.kernel.org/r/20220220031810.738362-19-damien.lemoal@opensource.wdc.com
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 5e6b23da4157..03c6fc85bd06 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3710,12 +3710,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	mb();
 
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
-		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
-		/* clear the flag */
-		pm8001_dev->id &= 0xBFFFFFFF;
-	} else
+		pm8001_dev->id &= ~NCQ_ABORT_ALL_FLAG;
+	} else {
 		t->task_done(t);
+	}
 
 	return 0;
 }
-- 
2.34.1

