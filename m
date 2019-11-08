Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB07F4990
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389941AbfKHLmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389926AbfKHLmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A29A3222C2;
        Fri,  8 Nov 2019 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213341;
        bh=9Z9PeVMgmbJrx/z7THVYJryxPwx40uyoJ4isNwdXKNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0KfU8ad9MoLI8cikiEqbifdnYIimo6wBHSbSF9/N35gOS9liKryB9u2PQC9pGVt6
         f40IwXoFluY0OrRAT1Itkz0b6r/MRK0JhhQhmAUckyANgyICNBq2w+b29U9h7NeCic
         Y2WOzLvI6MlG2rBp1MdSDNXgTB141M9GYsF9Ge0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lina Iyer <ilina@codeaurora.org>,
        "Raju P . L . S . S . S . N" <rplsssn@codeaurora.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 178/205] drivers: qcom: rpmh-rsc: clear wait_for_compl after use
Date:   Fri,  8 Nov 2019 06:37:25 -0500
Message-Id: <20191108113752.12502-178-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lina Iyer <ilina@codeaurora.org>

[ Upstream commit 09e97b6c8754c91470455e69ebd827b741f80af5 ]

The wait_for_compl register ensures the request sequence is maintained
when sending requests from the TCS. Clear the register after sending
active request and during invalidate of the sleep and wake TCS.

Reported-by: Raju P.L.S.S.S.N <rplsssn@codeaurora.org>
Signed-off-by: Lina Iyer <ilina@codeaurora.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index ee75da66d64bf..75bd9a83aef00 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -121,6 +121,7 @@ static int tcs_invalidate(struct rsc_drv *drv, int type)
 			return -EAGAIN;
 		}
 		write_tcs_reg_sync(drv, RSC_DRV_CMD_ENABLE, m, 0);
+		write_tcs_reg_sync(drv, RSC_DRV_CMD_WAIT_FOR_CMPL, m, 0);
 	}
 	bitmap_zero(tcs->slots, MAX_TCS_SLOTS);
 	spin_unlock(&tcs->lock);
@@ -239,6 +240,7 @@ static irqreturn_t tcs_tx_done(int irq, void *p)
 skip:
 		/* Reclaim the TCS */
 		write_tcs_reg(drv, RSC_DRV_CMD_ENABLE, i, 0);
+		write_tcs_reg(drv, RSC_DRV_CMD_WAIT_FOR_CMPL, i, 0);
 		write_tcs_reg(drv, RSC_DRV_IRQ_CLEAR, 0, BIT(i));
 		spin_lock(&drv->lock);
 		clear_bit(i, drv->tcs_in_use);
-- 
2.20.1

