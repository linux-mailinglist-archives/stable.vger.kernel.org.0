Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC233CDE3E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344168AbhGSPCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344090AbhGSO73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C9C5611C1;
        Mon, 19 Jul 2021 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709115;
        bh=G8kaSXHydDALx0th+NTQteMDHSlBM/XA3XY2yneF85E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iI51CIXOPJL+zpnBOiLfvy+g4vzatdBp3GIeUYKLbPQOvtO40nSSuMySBp7j4c6zZ
         aF+Z29sTEc3vmCohEAQFuMjzfjcrb0z8fHg+DlZmMonuw/TldYdJ6VbnKlq2cLkAcH
         a/5ufFGu3yxDWMHJ4ymxeFeu+IkQB/waKbqudx4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 225/421] mmc: block: Disable CMDQ on the ioctl path
Date:   Mon, 19 Jul 2021 16:50:36 +0200
Message-Id: <20210719144954.131915130@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

commit 70b52f09080565030a530a784f1c9948a7f48ca3 upstream.

According to the eMMC Spec:
"When command queuing is enabled (CMDQ Mode En bit in CMDQ_MODE_EN
field is set to ‘1’) class 11 commands are the only method through
which data transfer tasks can be issued. Existing data transfer
commands, namely CMD18/CMD17 and CMD25/CMD24, are not supported when
command queuing is enabled."
which means if CMDQ is enabled, the FFU commands will not be supported.
To fix this issue, just simply disable CMDQ on the ioctl path, and
re-enable CMDQ once ioctl request is completed.

Tested-by: Michael Brunner <Michael.Brunner@kontron.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 1e8e55b67030 (mmc: block: Add CQE support)
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210504203209.361597-1-huobean@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/block.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1054,6 +1054,12 @@ static void mmc_blk_issue_drv_op(struct
 
 	switch (mq_rq->drv_op) {
 	case MMC_DRV_OP_IOCTL:
+		if (card->ext_csd.cmdq_en) {
+			ret = mmc_cmdq_disable(card);
+			if (ret)
+				break;
+		}
+		/* fallthrough */
 	case MMC_DRV_OP_IOCTL_RPMB:
 		idata = mq_rq->drv_op_data;
 		for (i = 0, ret = 0; i < mq_rq->ioc_count; i++) {
@@ -1064,6 +1070,8 @@ static void mmc_blk_issue_drv_op(struct
 		/* Always switch back to main area after RPMB access */
 		if (rpmb_ioctl)
 			mmc_blk_part_switch(card, 0);
+		else if (card->reenable_cmdq && !card->ext_csd.cmdq_en)
+			mmc_cmdq_enable(card);
 		break;
 	case MMC_DRV_OP_BOOT_WP:
 		ret = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL, EXT_CSD_BOOT_WP,


