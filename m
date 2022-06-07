Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719BC541A0C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359478AbiFGV2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376551AbiFGV1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:27:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DD7151FF8;
        Tue,  7 Jun 2022 12:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06EA7B8220B;
        Tue,  7 Jun 2022 19:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740D8C385A5;
        Tue,  7 Jun 2022 19:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628517;
        bh=5UyCFB4gTsJjkenL8FLM1HvxfFX8u5ctKllpEI4wXVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usVaTPoTbSKHOzBniNa9cZwqc+9YmWTnoozCf+8wO9V/I4eys8PtUWwFDMbF2VrYI
         NMQmEp7eSLsPn5EgsYN7gTGpKaUEh6rUL3H7/UAfORuwa5e2qitvv1JMP26wdmdj4S
         5GOm0gFSSiy/6GnSqmEGjbLKrulJ2qDPpj0vanh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 357/879] scsi: ufs: core: Exclude UECxx from SFR dump list
Date:   Tue,  7 Jun 2022 18:57:55 +0200
Message-Id: <20220607165013.226875284@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit ef60031022eb6d972aac86ca26c98c33e1289436 ]

Some devices may return invalid or zeroed data during an UIC error
condition. In addition, reading these SFRs will clear them. This means the
subsequent error handling will not be able to see them and therefore no
error handling will be scheduled.

Skip reading these SFRs in ufshcd_dump_regs().

Link: https://lore.kernel.org/r/1648689845-33521-1-git-send-email-kwmad.kim@samsung.com
Fixes: d67247566450 ("scsi: ufs: Use explicit access size in ufshcd_dump_regs")
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f9caafa91bf..4c9eb4be449c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -113,8 +113,13 @@ int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 	if (!regs)
 		return -ENOMEM;
 
-	for (pos = 0; pos < len; pos += 4)
+	for (pos = 0; pos < len; pos += 4) {
+		if (offset == 0 &&
+		    pos >= REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER &&
+		    pos <= REG_UIC_ERROR_CODE_DME)
+			continue;
 		regs[pos / 4] = ufshcd_readl(hba, offset + pos);
+	}
 
 	ufshcd_hex_dump(prefix, regs, len);
 	kfree(regs);
-- 
2.35.1



