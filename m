Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4FF2F184F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388922AbhAKO2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731825AbhAKO2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 09:28:06 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3A3C061786;
        Mon, 11 Jan 2021 06:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L+JrZeQFviXuADS9yzDh+4MDUhWzTK6tO1mrS5qsi34=; b=o+Fs2ChgMgVFH9IFrdrBbZy06H
        tVSGSeN+1qPy5AX5+WVZPFakBLQHeRz76zSjH4GBRY/JSlKmMdobhbbxpeFxbcmbZ3jPd5vOASo1Z
        zYSWMc9pKGj/NpM721L8U52TB423Psp3J2sXuSFhBwhOLGpr0RtXmmj00sXWjM8jNNwQ4h72OK/Jp
        LQyZgcx35wn56cFEfYyYl8lWggIukdpW9qAvuQZ8gA24S+5STIFm0ALNWq7HmXezUXU0A7nRPka0H
        auJJmY8dVRes6K/oLFO0IK2sD2IlZAS+qGvx3qccGOnyed9/DZINai1yhdoyQAEBXfxhzgU/90xxt
        M1OlArTA==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=toshino.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mperttunen@nvidia.com>)
        id 1kyyAF-0003Er-Qx; Mon, 11 Jan 2021 16:27:23 +0200
From:   Mikko Perttunen <mperttunen@nvidia.com>
To:     thierry.reding@gmail.com, jonathanh@nvidia.com
Cc:     talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammed Fazal <mfazale@nvidia.com>, stable@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] i2c: tegra-bpmp: ignore DMA safe buffer flag
Date:   Mon, 11 Jan 2021 16:27:13 +0200
Message-Id: <20210111142713.3641208-1-mperttunen@nvidia.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: mperttunen@nvidia.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammed Fazal <mfazale@nvidia.com>

Ignore I2C_M_DMA_SAFE flag as it does not make a difference
for bpmp-i2c, but causes -EINVAL to be returned for valid
transactions.

Signed-off-by: Muhammed Fazal <mfazale@nvidia.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
This fixes failures seen with PMIC probing tools on
Tegra186+ boards.

 drivers/i2c/busses/i2c-tegra-bpmp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra-bpmp.c b/drivers/i2c/busses/i2c-tegra-bpmp.c
index ec7a7e917edd..998d4b21fb59 100644
--- a/drivers/i2c/busses/i2c-tegra-bpmp.c
+++ b/drivers/i2c/busses/i2c-tegra-bpmp.c
@@ -80,6 +80,9 @@ static int tegra_bpmp_xlate_flags(u16 flags, u16 *out)
 		flags &= ~I2C_M_RECV_LEN;
 	}
 
+	if (flags & I2C_M_DMA_SAFE)
+		flags &= ~I2C_M_DMA_SAFE;
+
 	return (flags != 0) ? -EINVAL : 0;
 }
 
-- 
2.30.0

