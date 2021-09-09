Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C13404D25
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243713AbhIIMA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243903AbhIIL52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CF656120C;
        Thu,  9 Sep 2021 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187934;
        bh=KGkS7OUjv67aEGceRwx3OK2/OzlLJ/+NxgxkJRzgIXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UH6/I2rEJATn/iMXg2eDsgPOOB89BN7gOTrdJI8cOTly0f1BTtKmZSvsucZaCtNLy
         vHJYhWfvsAESC8q+N4fADGyK0es397PiW3KebYeiR7i6d/oMSNRexjV2nQejzq8Gpi
         WtDfKtOvJc/aCyhOJpcXXrjUo8c2kjz+txbip9yHTA0eOPVMUMuRmuB62aaldzfHFw
         /EVQFY3+Mdpxj1OOz7NSFwkKSGMX/scUZ5eTWnYUxF6lzo9DTpHBJa6P1jzWWnR8LM
         4Pc0l3T2MHT3IiN1vK4arNs1QPJG0tRAxl5Kg/H4cTsYZaRib6YFvfQHguad6DrP4U
         MUL2i0aTti7hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 206/252] mmc: core: Avoid hogging the CPU while polling for busy for mmc ioctls
Date:   Thu,  9 Sep 2021 07:40:20 -0400
Message-Id: <20210909114106.141462-206-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 468108155b0f89cc08189cc33f9bacfe9da8a125 ]

When __mmc_blk_ioctl_cmd() calls card_busy_detect() to verify that the
card's states moves back into transfer state, the polling with CMD13 is
done without any delays in between the commands being sent.

Rather than fixing card_busy_detect() in this regards, let's instead
convert into using the common mmc_poll_for_busy(), which also helps us to
avoid open-coding.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20210702134229.357717-3-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 170343411f53..c30d0ab15539 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -605,7 +605,8 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 		 * Ensure RPMB/R1B command has completed by polling CMD13
 		 * "Send Status".
 		 */
-		err = card_busy_detect(card, MMC_BLK_TIMEOUT_MS, NULL);
+		err = mmc_poll_for_busy(card, MMC_BLK_TIMEOUT_MS, false,
+					MMC_BUSY_IO);
 	}
 
 	return err;
-- 
2.30.2

