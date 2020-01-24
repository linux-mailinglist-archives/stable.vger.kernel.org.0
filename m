Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31429147C64
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388069AbgAXJve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731650AbgAXJtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:49:33 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1227F208C4;
        Fri, 24 Jan 2020 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859372;
        bh=pgAspw4gQqFIsz3ReeSBt3sWrh+/EvDKqN1LZo//qtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P76txpL0Qe1ZS5HNROBxgDvIAZajyg0NvOXVBqhsmu34mGH4ByITAfmq9phxvRh5a
         dME5i8or5Leffp4s3+GGKkP1YIL4ejTaRMVOWHcWHVq671tXVOQ8i0LDFSGGcahtnG
         CSA9eGmEGaU9A/RNZq18ZwM2LEr78Wg3jlpFwIxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kao <michael.kao@mediatek.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 090/343] thermal: mediatek: fix register index error
Date:   Fri, 24 Jan 2020 10:28:28 +0100
Message-Id: <20200124092931.881691253@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kao <michael.kao@mediatek.com>

[ Upstream commit eb9aecd90d1a39601e91cd08b90d5fee51d321a6 ]

The index of msr and adcpnp should match the sensor
which belongs to the selected bank in the for loop.

Fixes: b7cf0053738c ("thermal: Add Mediatek thermal driver for mt2701.")
Signed-off-by: Michael Kao <michael.kao@mediatek.com>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mtk_thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/mtk_thermal.c b/drivers/thermal/mtk_thermal.c
index 1e61c09153c9a..76b92083744c9 100644
--- a/drivers/thermal/mtk_thermal.c
+++ b/drivers/thermal/mtk_thermal.c
@@ -407,7 +407,8 @@ static int mtk_thermal_bank_temperature(struct mtk_thermal_bank *bank)
 	u32 raw;
 
 	for (i = 0; i < conf->bank_data[bank->id].num_sensors; i++) {
-		raw = readl(mt->thermal_base + conf->msr[i]);
+		raw = readl(mt->thermal_base +
+			    conf->msr[conf->bank_data[bank->id].sensors[i]]);
 
 		temp = raw_to_mcelsius(mt,
 				       conf->bank_data[bank->id].sensors[i],
@@ -544,7 +545,8 @@ static void mtk_thermal_init_bank(struct mtk_thermal *mt, int num,
 
 	for (i = 0; i < conf->bank_data[num].num_sensors; i++)
 		writel(conf->sensor_mux_values[conf->bank_data[num].sensors[i]],
-		       mt->thermal_base + conf->adcpnp[i]);
+		       mt->thermal_base +
+		       conf->adcpnp[conf->bank_data[num].sensors[i]]);
 
 	writel((1 << conf->bank_data[num].num_sensors) - 1,
 	       mt->thermal_base + TEMP_MONCTL0);
-- 
2.20.1



