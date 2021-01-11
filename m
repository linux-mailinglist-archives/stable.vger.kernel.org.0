Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C7D2F1A52
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388323AbhAKP7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731804AbhAKP7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:59:09 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1704EC061786;
        Mon, 11 Jan 2021 07:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7Po4id9eWkY7uvToizGBFW5yEu2kvXRu4dj6jXQtgHo=; b=ym6Fttri1WKbSAKbRIudWCv2rr
        eLJkUbLVQ60OpUYu48+3KrSg7PD+BhBhyQ4QEdpmIv9+FsLCLh/mrf3qORhjseOJ2SYh0VeL2sVmn
        dx8As0clkznvKlAizDsQzTS9LO0daZvJxmaIwE6Md2MjR+lsI3EmraL0ihu3noOs0y0d0Q3UGlYgG
        QaErLfo8YkkFaZRDLfCNKliqu7Xag1ftCDxVcr+UdxXUMzk8X6hkJ9RT9N40shXOSnaA46Mlnchky
        1ljxHO1jjp8lhnaRoOBjYU2Y8+WuSjAFHw0KTbQQ6L6BTiRBq3/Y5Tv4zS3obWLD9MU9tmfK/CSsA
        bTe55VaQ==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=toshino.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mperttunen@nvidia.com>)
        id 1kyzaN-0005h1-89; Mon, 11 Jan 2021 17:58:27 +0200
From:   Mikko Perttunen <mperttunen@nvidia.com>
To:     thierry.reding@gmail.com, jonathanh@nvidia.com
Cc:     talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammed Fazal <mfazale@nvidia.com>, stable@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2] i2c: tegra-bpmp: ignore DMA safe buffer flag
Date:   Mon, 11 Jan 2021 17:58:16 +0200
Message-Id: <20210111155816.3656820-1-mperttunen@nvidia.com>
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
v2:
- Remove unnecessary check for if the bit is set
---
 drivers/i2c/busses/i2c-tegra-bpmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra-bpmp.c b/drivers/i2c/busses/i2c-tegra-bpmp.c
index ec7a7e917edd..aa6685cabde3 100644
--- a/drivers/i2c/busses/i2c-tegra-bpmp.c
+++ b/drivers/i2c/busses/i2c-tegra-bpmp.c
@@ -80,6 +80,8 @@ static int tegra_bpmp_xlate_flags(u16 flags, u16 *out)
 		flags &= ~I2C_M_RECV_LEN;
 	}
 
+	flags &= ~I2C_M_DMA_SAFE;
+
 	return (flags != 0) ? -EINVAL : 0;
 }
 
-- 
2.30.0

