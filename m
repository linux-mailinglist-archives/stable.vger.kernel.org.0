Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32C84FD666
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353617AbiDLHqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357105AbiDLHjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE065DEB4;
        Tue, 12 Apr 2022 00:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93ADBB81A8F;
        Tue, 12 Apr 2022 07:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FC3C385A1;
        Tue, 12 Apr 2022 07:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747532;
        bh=RVCl0QueOUEdBG+WdafdDuCg8pAcvRppNDasLe0JeiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0aSQznAjyslXpfuDE0ybt9nm6oYgXMZa/ZAQCJd4aQv3k7rqn0lM6Ulx+su7C/wy
         XPrOPuDswcL3AX0kUg5w7BTdfGhTppcfJ+2D/bnRkP6utik/pHg8YtePWw9YFhoOoI
         pT8Is2NSr9vwegP/AVXDNP069FGt1mj040LjXf2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 106/343] scsi: pm8001: Fix memory leak in pm8001_chip_fw_flash_update_req()
Date:   Tue, 12 Apr 2022 08:28:44 +0200
Message-Id: <20220412062954.155454566@linuxfoundation.org>
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
index ccc7f53ddbd6..27ead825c2bb 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4880,8 +4880,10 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
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
2.35.1



