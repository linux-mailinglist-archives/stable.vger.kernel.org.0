Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBFF34C724
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhC2INE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhC2IL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C46561974;
        Mon, 29 Mar 2021 08:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005487;
        bh=qX4f7AjnGP5QMjGMo3DlAfac9XnlSecuHhcjJ5ncl5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+5ZF0xkj47hjF+DxEJSt8vPF/cfBLkKpTtGUCVsXVYNQXlF8Wk5JE87lkB0HyE4O
         fQGTVY3u7bHzLVZ8glVQZ+OsSp9EYhY++vqun4RPCt3I5VoB/aVSi80TMgRDxoLWXo
         lKPspW5EiXMbsW/QaU3lhZfXGcxngLRioDpu40ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Thiery <heiko.thiery@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/111] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Mon, 29 Mar 2021 09:57:10 +0200
Message-Id: <20210329075615.273396431@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
index 945643c02615..49fad118988b 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -382,9 +382,16 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
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



