Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4438E57634
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfF0AgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbfF0AgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:36:21 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864E9217F4;
        Thu, 27 Jun 2019 00:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595780;
        bh=GNN0sR4e16+0nWy1iWP+tAoGWftpGYQrJW02a8FU0ZM=;
        h=From:To:Cc:Subject:Date:From;
        b=YCVxxbKFebNXTj8jsQ8BlVB0amCsEcEDcUjBu1Ltjj8tcVYrELN63tHMmFrj1XLAf
         ZL4wU9ujYT7j0Pz40i1QqhjSZ2mTl3INDzlFdpW59BpAcVjPF6G4PZDGVgZMJzPbSG
         opW/wrKUkEiV9G21fcTe6mxFBDzQzAgat2k62ie4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/60] soc: brcmstb: Fix error path for unsupported CPUs
Date:   Wed, 26 Jun 2019 20:35:16 -0400
Message-Id: <20190627003616.20767-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 490cad5a3ad6ef0bfd3168a5063140b982f3b22a ]

In case setup_hifcpubiuctrl_regs() returns an error, because of e.g:
an unsupported CPU type, just catch that error and return instead of
blindly continuing with the initialization. This fixes a NULL pointer
de-reference with the code continuing without having a proper array of
registers to use.

Fixes: 22f7a9116eba ("soc: brcmstb: Correct CPU_CREDIT_REG offset for Brahma-B53 CPUs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/brcmstb/biuctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/bcm/brcmstb/biuctrl.c b/drivers/soc/bcm/brcmstb/biuctrl.c
index 6d89ebf13b8a..c16273b31b94 100644
--- a/drivers/soc/bcm/brcmstb/biuctrl.c
+++ b/drivers/soc/bcm/brcmstb/biuctrl.c
@@ -246,7 +246,9 @@ static int __init brcmstb_biuctrl_init(void)
 	if (!np)
 		return 0;
 
-	setup_hifcpubiuctrl_regs(np);
+	ret = setup_hifcpubiuctrl_regs(np);
+	if (ret)
+		return ret;
 
 	ret = mcp_write_pairing_set();
 	if (ret) {
-- 
2.20.1

