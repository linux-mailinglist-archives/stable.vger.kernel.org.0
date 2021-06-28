Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1925C3B629C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhF1Osr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235591AbhF1Opg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81CE861CD1;
        Mon, 28 Jun 2021 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890853;
        bh=OjzcSXUTvnbomlLNrFQeDaMhs5tDni2gPGRoCKFKcQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsO1lNz16ESTqkUvLcf4I/dG/iZ9aF+vfBgnxaSyBUdRc2mmPcwDeolEEj5LzeTmM
         tCW8a459nUUEocjg9MJyfUSAxkvng77aVaBLHDJfcpTeHZOvbYs2sFPjzI/EU54DYT
         skzOj89vuyJ4hmaKuLyWJOjmVt6NOfbBfkBsZlixLjNrrV1YrEUghSJNmAtE0LSuPM
         CiEhrx9Q8QPC2/XyTIDJTRnDMhLC3uIXw+WznXlwgLFYJvKEUCYrcr+rtRP7pQ/diS
         fCjlqE0oasNNm27a4oHgTUgnKBfOnDabh++6gCG/eUtQjsi9IuMaK5uTA7nBmbCz/O
         PE34ZoNp5C2hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 075/109] net: fec_ptp: add clock rate zero check
Date:   Mon, 28 Jun 2021 10:32:31 -0400
Message-Id: <20210628143305.32978-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index eca65d49decb..52a811f91384 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -597,6 +597,10 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
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

