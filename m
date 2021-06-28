Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A151B3B63F5
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbhF1PCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235956AbhF1O77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:59:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0F2161D60;
        Mon, 28 Jun 2021 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891243;
        bh=0GmvVOHkxS3zDugced8sL6PhjzPR+8l3H4fe45G+F+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sdiw5svcmU2sWjsx8wLIJRaM0W/owR2Qi0nUe7pgH9AAES2fcIgv6XsoRRtae2hId
         rmIRHsOieOaTm/plbKwsLe6VKJlNV0RRgx6b5rVbgBDQUia2iY1Tya6FViDYae5yLm
         1OKNPhV96oVCVCNCKUNQUxg4fpQhks0SnEfPi7KqqFu6OOW8jOw7nliOBfzn3Y249O
         NMHWLaNaoXN57diozQTTCVdx1UzbaBHX+kfXT6UCll74M9MO+S1tKWT3OUl3RzVaAY
         v/EATfaTAVL4hpLD0k5WGIq9jcBlSqj+vpHfJjj1MnqYcMEirEwhHmgn1cnYi0ofWO
         lghxnmxRAHr7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 44/71] net: fec_ptp: add clock rate zero check
Date:   Mon, 28 Jun 2021 10:39:36 -0400
Message-Id: <20210628144003.34260-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

commit cb3cefe3f3f8af27c6076ef7d1f00350f502055d upstream.

Add clock rate zero check to fix coverity issue of "divide by 0".

Fixes: commit 85bd1798b24a ("net: fec: fix spin_lock dead lock")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 123181612595..031d4b3a544c 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -586,6 +586,10 @@ void fec_ptp_init(struct platform_device *pdev)
 	fep->ptp_caps.enable = fec_ptp_enable;
 
 	fep->cycle_speed = clk_get_rate(fep->clk_ptp);
+	if (!fep->cycle_speed) {
+		fep->cycle_speed = NSEC_PER_SEC;
+		dev_err(&fep->pdev->dev, "clk_ptp clock rate is zero\n");
+	}
 	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
 
 	spin_lock_init(&fep->tmreg_lock);
-- 
2.30.2

