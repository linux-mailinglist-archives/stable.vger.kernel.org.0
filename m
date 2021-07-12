Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9293C472F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbhGLGbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234931AbhGLGaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6722F61283;
        Mon, 12 Jul 2021 06:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071284;
        bh=y/MxTgp0vK74yPTxvMNX8UTk6/jxeDv7w0Orj9HWdH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtjMHpnoV4AIU4URhHADjJXpjEUH8g2MO8aZ92WMIDGqAO5nxNznbQIVtesAGa7df
         EIl9DWOVDnAh5Uw2peI5phrFLnHqt7Mc4Kv7bAyOFPSEg+/uix0YczLMj/HLgvjnmK
         gtmbu9w2aPDw+v4PhpqsYN8n1uuMhkWSlet4t+cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 346/348] mmc: block: Disable CMDQ on the ioctl path
Date:   Mon, 12 Jul 2021 08:12:10 +0200
Message-Id: <20210712060750.048844708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
@@ -1053,6 +1053,12 @@ static void mmc_blk_issue_drv_op(struct
 
 	switch (mq_rq->drv_op) {
 	case MMC_DRV_OP_IOCTL:
+		if (card->ext_csd.cmdq_en) {
+			ret = mmc_cmdq_disable(card);
+			if (ret)
+				break;
+		}
+		fallthrough;
 	case MMC_DRV_OP_IOCTL_RPMB:
 		idata = mq_rq->drv_op_data;
 		for (i = 0, ret = 0; i < mq_rq->ioc_count; i++) {
@@ -1063,6 +1069,8 @@ static void mmc_blk_issue_drv_op(struct
 		/* Always switch back to main area after RPMB access */
 		if (rpmb_ioctl)
 			mmc_blk_part_switch(card, 0);
+		else if (card->reenable_cmdq && !card->ext_csd.cmdq_en)
+			mmc_cmdq_enable(card);
 		break;
 	case MMC_DRV_OP_BOOT_WP:
 		ret = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL, EXT_CSD_BOOT_WP,


