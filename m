Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6A83B6459
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhF1PHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237241AbhF1PF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3094461CFD;
        Mon, 28 Jun 2021 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891409;
        bh=0GmvVOHkxS3zDugced8sL6PhjzPR+8l3H4fe45G+F+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iB8HrBkn3JD8bNZ6IPP/cF3KA0sRfKoUvPEWaT7D2GYrYD67TC6mVNzffIs5gHxe4
         p9nocKG62qaKz8wXmRR6PW+u09gcTwm0dcAp4iYF/j0yF/T03W7CXLNvG1KVZPJ4T+
         Zcugli/zw65BQAZ38CIn9eM1dObx4yHgWqBopjDNS784ZCe6wqCH0ozc7cVxev4LAY
         1S3Z6nOSbifW1HEuzAY2zSJfm4enqSSW6l+rBdB7BE2b/hlwIdCf/+xdPkVt1CwH6R
         nLojr7o/lbToXPskWfhFrev73JIk6VN9ELcTZu6VUiU05ysATb1JZPIcA6TY+SwlI6
         worCSesiQ5ekw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 37/57] net: fec_ptp: add clock rate zero check
Date:   Mon, 28 Jun 2021 10:42:36 -0400
Message-Id: <20210628144256.34524-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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

