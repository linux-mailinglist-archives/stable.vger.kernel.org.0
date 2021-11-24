Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7305F45BF05
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344490AbhKXMyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:54:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344850AbhKXMwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E06E61361;
        Wed, 24 Nov 2021 12:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757013;
        bh=vsgf6ojtPPh3+XJs3JAtHG1BYesGktGJ+DpxM5unH7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyqyWzcpZl0bSh5+jiFMPzIqBC5GnsRuEEBFD34Aia44DtZkG6Vabfm5r+SLfPTUE
         4FSW4N9npUOu0FEbKDsI21U78ANCYD+j3Ba/VhAN7QBNR4x3x3GtHJCHdzFyC5yvbw
         +UiHMov6mixJL8kwSM35CS4VxlA5OsFH3XlETZ7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/323] cavium: Fix return values of the probe function
Date:   Wed, 24 Nov 2021 12:53:38 +0100
Message-Id: <20211124115719.828367938@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit c69b2f46876825c726bd8a97c7fa852d8932bc32 ]

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 99eea9e6a8ea6..0fbb0dee2dcfd 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1223,7 +1223,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (ret < 0) {
 		netdev_err(nic->netdev,
 			   "Req for #%d msix vectors failed\n", nic->num_vec);
-		return 1;
+		return ret;
 	}
 
 	sprintf(nic->irq_name[irq], "%s Mbox", "NICVF");
@@ -1242,7 +1242,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (!nicvf_check_pf_ready(nic)) {
 		nicvf_disable_intr(nic, NICVF_INTR_MBOX, 0);
 		nicvf_unregister_interrupts(nic);
-		return 1;
+		return -EIO;
 	}
 
 	return 0;
-- 
2.33.0



