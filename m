Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD550159C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245450AbiDNNn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344060AbiDNNaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BA81D3;
        Thu, 14 Apr 2022 06:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A3060C14;
        Thu, 14 Apr 2022 13:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36C9C385A5;
        Thu, 14 Apr 2022 13:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942837;
        bh=D787sV8nd8+NiBn7AX3kI7jSFeIEtlglHGLgfhaBEzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfUXXisNz6OuQY+UF0cGP9rlHefyZPq2FVBZR8wTwR7cVAz9KvteI1mwSShbwbeAy
         pThIWerjMTYVRjOw4G0qVqDitOJIDGbxrYkERlYhDF0glIt4pvLT9dfFxxDtL9ZDnN
         DE1lsoUllIk1hpKUWmZHHMKinEYyaLtu8r4yM3c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 277/338] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
Date:   Thu, 14 Apr 2022 15:13:00 +0200
Message-Id: <20220414110846.772084316@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 5eabea5ca6a7..d532230c62f3 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3777,12 +3777,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
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
2.35.1



