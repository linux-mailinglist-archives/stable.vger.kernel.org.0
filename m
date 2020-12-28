Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E812E3DA2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501923AbgL1OSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501920AbgL1OSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC5F620791;
        Mon, 28 Dec 2020 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165044;
        bh=PwOG6pmQlyMhOuTGnEIoMhyMbWfKZeMtPuu38FTi1x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltKSRXM+T3vWMAyJmLgkK/pEQK3U81QLE/6ByWrWXBcgMxD1v0PwQcKi3DtYDtjVz
         lFt4//MzeELB3ZESapXE6rmm81bAsp8wnzMrAl5LaO3LH7F4pu20m29Zy8NmnPOgO8
         2GuoDN4+xEG33OhZniDLDbF8up3Csw8wOxbK2ClY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/717] can: m_can: m_can_config_endisable(): remove double clearing of clock stop request bit
Date:   Mon, 28 Dec 2020 13:46:29 +0100
Message-Id: <20201228125039.739150897@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit c9f4cad6cdfe350ce2637e57f7f2aa7ff326bcc6 ]

The CSR bit is already cleared when arriving here so remove this section of
duplicate code.

The registers set in m_can_config_endisable() is set to same exact values as
before this patch.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Sriram Dash <sriram.dash@samsung.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20191211063227.84259-1-sean@geanix.com
Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 61a93b1920379..7fc4ac1582afc 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -380,10 +380,6 @@ void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
 		cccr &= ~CCCR_CSR;
 
 	if (enable) {
-		/* Clear the Clock stop request if it was set */
-		if (cccr & CCCR_CSR)
-			cccr &= ~CCCR_CSR;
-
 		/* enable m_can configuration */
 		m_can_write(cdev, M_CAN_CCCR, cccr | CCCR_INIT);
 		udelay(5);
-- 
2.27.0



