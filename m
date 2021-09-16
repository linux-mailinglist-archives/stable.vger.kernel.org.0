Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4634440E7E1
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349834AbhIPRnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353971AbhIPRh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99D4F63237;
        Thu, 16 Sep 2021 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810995;
        bh=KGkS7OUjv67aEGceRwx3OK2/OzlLJ/+NxgxkJRzgIXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J21pAywJtBw/Q1wRlVXMnbTpoUs8st0+AbvrTU6/oG3wvcFT158KqUUEjJ99as5QM
         hITLLCL4Rnrr1wC8z9v+1PXLVZOq0nvwVj9eXHRdA03Lu5HNo+1GMd6Ot5xPpdvO/e
         WUGxswluU04AqZZTMfXxMWhLbPUOxtEDftVcpkbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 345/432] mmc: core: Avoid hogging the CPU while polling for busy for mmc ioctls
Date:   Thu, 16 Sep 2021 18:01:34 +0200
Message-Id: <20210916155822.522528425@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



