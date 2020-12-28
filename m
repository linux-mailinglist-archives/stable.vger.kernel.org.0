Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4472E3ADF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404243AbgL1Nmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404280AbgL1Nmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC4E522AAA;
        Mon, 28 Dec 2020 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162948;
        bh=wVi6T/8gGEmINXaUTqxXXtxgQN3ORT6vIJsJZ35/0Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6tW6cKN7DKiDYWvd1nxuP95cSCAUUae4GO/nJJ3nILNLsfsJCzuCP9VIJok+y0Xp
         to3XymU80nquIElGUswpwYb5hVYV332wA6+9BXUzs2jVowFHCPKKE/SnGiUIpYS8Yz
         9mGR4tsZPCtnj27zujWak0sltRiu6veIbNDXRCQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/453] spi: tegra20-sflash: fix reference leak in tegra_sflash_resume
Date:   Mon, 28 Dec 2020 13:45:53 +0100
Message-Id: <20201228124942.845353920@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 3482e797ab688da6703fe18d8bad52f94199f4f2 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in tegra_sflash_resume, so we should fix it.

Fixes: 8528547bcc336 ("spi: tegra: add spi driver for sflash controller")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201103141323.5841-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-sflash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index a841a7250d14b..ecb620169753a 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -551,6 +551,7 @@ static int tegra_sflash_resume(struct device *dev)
 
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		dev_err(dev, "pm runtime failed, e = %d\n", ret);
 		return ret;
 	}
-- 
2.27.0



