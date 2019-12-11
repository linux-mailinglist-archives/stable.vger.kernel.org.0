Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CB411B619
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbfLKP6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731599AbfLKPOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0074A2468B;
        Wed, 11 Dec 2019 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077252;
        bh=8+7f+mNfpMs8RuOsUsfQOF8mbmo5DGpCF2BOjMYvpDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRdqNckNmt5zh2hWh6mBQqb00leobuKj/PIaGj2sIaZQPgEoaQ4iIFFV7NB92E/8h
         z1DhshSBXGXAInQOTuBY0G263meLwn9u++atGqFo23ULY8jea2/CYGLhqfjVj7Eq0Y
         L3GFRU1/pCHSl2Ca3hITc1Ci7XdDY+covH3bda2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Baluta <daniel.baluta@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Richard Zhu <hongxing.zhu@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 129/134] mailbox: imx: Fix Tx doorbell shutdown path
Date:   Wed, 11 Dec 2019 10:11:45 -0500
Message-Id: <20191211151150.19073-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit bf159d151a0b844be28882f39e316b5800acaa2b ]

Tx doorbell is handled by txdb_tasklet and doesn't
have an associated IRQ.

Anyhow, imx_mu_shutdown ignores this and tries to
free an IRQ that wasn't requested for Tx DB resulting
in the following warning:

[    1.967644] Trying to free already-free IRQ 26
[    1.972108] WARNING: CPU: 2 PID: 157 at kernel/irq/manage.c:1708 __free_irq+0xc0/0x358
[    1.980024] Modules linked in:
[    1.983088] CPU: 2 PID: 157 Comm: kworker/2:1 Tainted: G
[    1.993524] Hardware name: Freescale i.MX8QXP MEK (DT)
[    1.998668] Workqueue: events deferred_probe_work_func
[    2.003812] pstate: 60000085 (nZCv daIf -PAN -UAO)
[    2.008607] pc : __free_irq+0xc0/0x358
[    2.012364] lr : __free_irq+0xc0/0x358
[    2.016111] sp : ffff00001179b7e0
[    2.019422] x29: ffff00001179b7e0 x28: 0000000000000018
[    2.024736] x27: ffff000011233000 x26: 0000000000000004
[    2.030053] x25: 000000000000001a x24: ffff80083bec74d4
[    2.035369] x23: 0000000000000000 x22: ffff80083bec7588
[    2.040686] x21: ffff80083b1fe8d8 x20: ffff80083bec7400
[    2.046003] x19: 0000000000000000 x18: ffffffffffffffff
[    2.051320] x17: 0000000000000000 x16: 0000000000000000
[    2.056637] x15: ffff0000111296c8 x14: ffff00009179b517
[    2.061953] x13: ffff00001179b525 x12: ffff000011142000
[    2.067270] x11: ffff000011129f20 x10: ffff0000105da970
[    2.072587] x9 : 00000000ffffffd0 x8 : 0000000000000194
[    2.077903] x7 : 612065657266206f x6 : ffff0000111e7b09
[    2.083220] x5 : 0000000000000003 x4 : 0000000000000000
[    2.088537] x3 : 0000000000000000 x2 : 00000000ffffffff
[    2.093854] x1 : 28b70f0a2b60a500 x0 : 0000000000000000
[    2.099173] Call trace:
[    2.101618]  __free_irq+0xc0/0x358
[    2.105021]  free_irq+0x38/0x98
[    2.108170]  imx_mu_shutdown+0x90/0xb0
[    2.111921]  mbox_free_channel.part.2+0x24/0xb8
[    2.116453]  mbox_free_channel+0x18/0x28

This bug is present from the beginning of times.

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index d28bbd47ff882..afe625e88a5c5 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -214,8 +214,10 @@ static void imx_mu_shutdown(struct mbox_chan *chan)
 	struct imx_mu_priv *priv = to_imx_mu_priv(chan->mbox);
 	struct imx_mu_con_priv *cp = chan->con_priv;
 
-	if (cp->type == IMX_MU_TYPE_TXDB)
+	if (cp->type == IMX_MU_TYPE_TXDB) {
 		tasklet_kill(&cp->txdb_tasklet);
+		return;
+	}
 
 	switch (cp->type) {
 	case IMX_MU_TYPE_TX:
-- 
2.20.1

