Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F1D4FD67D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353790AbiDLHqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357092AbiDLHjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB99FD4;
        Tue, 12 Apr 2022 00:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8921616E7;
        Tue, 12 Apr 2022 07:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB604C385A5;
        Tue, 12 Apr 2022 07:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747507;
        bh=qBiFHKXgg2zD6b/5j7HVuOH2dTTTHrfHFZb8RUAUM90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9k9PdVxonjhQ9cFQOGdEV36tdOvSHzxYVmBclcCQ5oUy5S8AcqmcKBFuPzzdYnPo
         BGDJwvOb67LqamlIouSjb0/vf8zqQnN9scMABCSbUtMUo2OxrIP+QgjnSphLmBVSHx
         SDhdHmkQkm4zpp5uR2UZRksxbbq8QiIWsxbdL0v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 102/343] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
Date:   Tue, 12 Apr 2022 08:28:40 +0200
Message-Id: <20220412062954.042654150@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index d853e8d0195a..4f4a9dcb6a1e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3706,12 +3706,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
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



