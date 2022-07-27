Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3158582DE7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiG0REu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241472AbiG0RET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7A56E8A9;
        Wed, 27 Jul 2022 09:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86C13B821B6;
        Wed, 27 Jul 2022 16:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04B4C433D6;
        Wed, 27 Jul 2022 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939934;
        bh=NIaVVLE+pEn8Ee5MvqbaxjbH8CI2HF9VkpWMB7V+KKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FokX5ckaCjighnTfT0/wfWGnDurcnCc3kwNcQbe2I3P5+OHvRfOXw7WOd0qQ1UpM
         /1Ve9dGkpVOXGgEcd13e+NRDLiMX7bCWAoznzo3EjoKrPgy/gRgX9wwzWPFrzpjUAw
         wYpiVyjJIOyO7ApPTt0KFKV+Bkmk/m967TE+mRFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/201] scsi: ufs: core: Drop loglevel of WriteBoost message
Date:   Wed, 27 Jul 2022 18:09:12 +0200
Message-Id: <20220727161028.870672255@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 2ae57c995003a7840cb6b5ec5f0c06193695321b ]

Commit '3b5f3c0d0548 ("scsi: ufs: core: Tidy up WB configuration code")'
changed the log level of the write boost enable/disable notification from
debug to info. This results in a lot of noise in the kernel log during
normal operation.

Drop it back to debug level to avoid this.

Link: https://lore.kernel.org/r/20220709000027.3929970-1-bjorn.andersson@linaro.org
Fixes: 3b5f3c0d0548 ("scsi: ufs: core: Tidy up WB configuration code")
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Acked-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5c9a31f18b7f..4a7248421bcd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5638,7 +5638,7 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 	}
 
 	hba->dev_info.wb_enabled = enable;
-	dev_info(hba->dev, "%s Write Booster %s\n",
+	dev_dbg(hba->dev, "%s Write Booster %s\n",
 			__func__, enable ? "enabled" : "disabled");
 
 	return ret;
-- 
2.35.1



