Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCD334C9D1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhC2Idz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233733AbhC2IbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:31:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64FE161581;
        Mon, 29 Mar 2021 08:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006681;
        bh=GT+lisKyj04s1FvVx444rz72yjzpOZdk93r+kgqXFr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3FYf435vCijuGrxeE6PzdUuH/lYywS+nhhCA/T3tnOnTzYeXcLYr0dKzTVoftP/N
         p9zIYppWS5D43cHaHvkjY0r+HGVjInTS2kMHaKIX2FL2YwkMEg7OM3OmCIwOBZKMd5
         b3Ekuiu2S2E+kH3cBmaOOiGlBn1DMw1Y3O0ig2KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Thiery <heiko.thiery@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 004/254] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Mon, 29 Mar 2021 09:55:20 +0200
Message-Id: <20210329075633.279539298@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Thiery <heiko.thiery@gmail.com>

[ Upstream commit 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5 ]

When accessing the timecounter register on an i.MX8MQ the kernel hangs.
This is only the case when the interface is down. This can be reproduced
by reading with 'phc_ctrl eth0 get'.

Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
the igp clock is disabled when the interface is down and leads to a
system hang.

So we check if the ptp clock status before reading the timecounter
register.

Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20210225211514.9115-1-heiko.thiery@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 2e344aada4c6..1753807cbf97 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -377,9 +377,16 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	u64 ns;
 	unsigned long flags;
 
+	mutex_lock(&adapter->ptp_clk_mutex);
+	/* Check the ptp clock */
+	if (!adapter->ptp_clk_on) {
+		mutex_unlock(&adapter->ptp_clk_mutex);
+		return -EINVAL;
+	}
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 	ns = timecounter_read(&adapter->tc);
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+	mutex_unlock(&adapter->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
-- 
2.30.1



