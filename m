Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F933CE18B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349298AbhGSP01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348066AbhGSPYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870AF613F9;
        Mon, 19 Jul 2021 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710471;
        bh=dFc4zi4FSS9M1NxGHealxsT356amzx9zD8JG1iSt1lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rb7F397SSYZi4WAwxIZ8CYKMt+KP0lCvUl/uZCnsFys7ReckCEf3pitDxgMebdUr2
         saUzKH+Y4Nz/Roan/lUFjH7HCYqTrqSJd2pI0xC73Bm7aIK8bMoONeqFkTxUBCTzuI
         JIRuvUcBU66T/o0Q0u0Gb+vb+h6atnaK3nQtU6H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/243] firmware: turris-mox-rwtm: fail probing when firmware does not support hwrng
Date:   Mon, 19 Jul 2021 16:54:20 +0200
Message-Id: <20210719144948.376223234@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 2eab59cf0d2036a5a9e264f719b71c21ccf679c2 ]

When Marvell's rWTM firmware, which does not support the GET_RANDOM
command, is used, kernel prints an error message
  hwrng: no data available
every 10 seconds.

Fail probing of this driver if the rWTM firmware does not support the
GET_RANDOM command.

Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 0f9e40a28fb0..2b56dd05961f 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -260,6 +260,27 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 	return 0;
 }
 
+static int check_get_random_support(struct mox_rwtm *rwtm)
+{
+	struct armada_37xx_rwtm_tx_msg msg;
+	int ret;
+
+	msg.command = MBOX_CMD_GET_RANDOM;
+	msg.args[0] = 1;
+	msg.args[1] = rwtm->buf_phys;
+	msg.args[2] = 4;
+
+	ret = mbox_send_message(rwtm->mbox, &msg);
+	if (ret < 0)
+		return ret;
+
+	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
+	if (ret < 0)
+		return ret;
+
+	return mox_get_status(MBOX_CMD_GET_RANDOM, rwtm->reply.retval);
+}
+
 static int mox_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct mox_rwtm *rwtm = (struct mox_rwtm *) rng->priv;
@@ -497,6 +518,13 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	if (ret < 0)
 		dev_warn(dev, "Cannot read board information: %i\n", ret);
 
+	ret = check_get_random_support(rwtm);
+	if (ret < 0) {
+		dev_notice(dev,
+			   "Firmware does not support the GET_RANDOM command\n");
+		goto free_channel;
+	}
+
 	rwtm->hwrng.name = DRIVER_NAME "_hwrng";
 	rwtm->hwrng.read = mox_hwrng_read;
 	rwtm->hwrng.priv = (unsigned long) rwtm;
-- 
2.30.2



