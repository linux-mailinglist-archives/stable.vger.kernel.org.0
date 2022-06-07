Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE0B5413B7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354363AbiFGUGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358503AbiFGUEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8931C2D50;
        Tue,  7 Jun 2022 11:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85321611B9;
        Tue,  7 Jun 2022 18:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961CBC385A2;
        Tue,  7 Jun 2022 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626343;
        bh=e3k05X3Y4XeqYlQTuCd7kBtR2dE2CgImtDFaVhzrFiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Re/8rVgWnP4KpqQYfJqC5EoMREFiigGJyn34+iVQzOFzLciGh0vp4/VQEmmoD3/v7
         9dKKi64NP/mPkOYxrnAepKSW8zSjZFQAFpehN9B+sTSWA/wCPggoE0jL6dfnlyqRmj
         ayBQQy7drOOVaExaXjRf0/lGX981PzIYLwXKAJwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 303/772] scsi: ufs: core: Exclude UECxx from SFR dump list
Date:   Tue,  7 Jun 2022 18:58:15 +0200
Message-Id: <20220607164957.953298727@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 5696e52c76e9..05d2155dbf40 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -115,8 +115,13 @@ int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
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



