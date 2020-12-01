Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0371A2C9D7F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388806AbgLAJY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387855AbgLAJGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E294E20671;
        Tue,  1 Dec 2020 09:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813549;
        bh=MJGcRw+qCH6CshT5sWPBdRpx9kibcvm8lmKAFud8M/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5uk0V+ed73M0QeW/ChvP1abtDVUCatcq8Lfk6LeBAOIzYqf2xl5SXWUz4xqjweUJ
         EynE4PjWkJKNi1wpORDPT9JwpbjJhlsB2mVy4U62UFop3VDsZq0MCNfVoM3ZUbpvf4
         mmbITzHOz4YBXIWuGLCG7yYlqGPk2y9YOJdfK87A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mario Huettel <mario.huettel@gmx.net>,
        Sriram Dash <sriram.dash@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 77/98] can: m_can: fix nominal bitiming tseg2 min for version >= 3.1
Date:   Tue,  1 Dec 2020 09:53:54 +0100
Message-Id: <20201201084658.824064234@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit e3409e4192535fbcc86a84b7a65d9351f46039ec ]

At lest the revision 3.3.0 of the bosch m_can IP core specifies that valid
register values for "Nominal Time segment after sample point (NTSEG2)" are from
1 to 127. As the hardware uses a value of one more than the programmed value,
mean tseg2_min is 2.

This patch fixes the tseg2_min value accordingly.

Cc: Dan Murphy <dmurphy@ti.com>
Cc: Mario Huettel <mario.huettel@gmx.net>
Acked-by: Sriram Dash <sriram.dash@samsung.com>
Link: https://lore.kernel.org/r/20201124190751.3972238-1-mkl@pengutronix.de
Fixes: b03cfc5bb0e1 ("can: m_can: Enable M_CAN version dependent initialization")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index eafdb4441d441..f9a2a9ecbac9e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -990,7 +990,7 @@ static const struct can_bittiming_const m_can_bittiming_const_31X = {
 	.name = KBUILD_MODNAME,
 	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
 	.tseg1_max = 256,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
+	.tseg2_min = 2,		/* Time segment 2 = phase_seg2 */
 	.tseg2_max = 128,
 	.sjw_max = 128,
 	.brp_min = 1,
-- 
2.27.0



