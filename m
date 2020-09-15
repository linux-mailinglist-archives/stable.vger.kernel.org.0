Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7962426B783
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgIPAYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgIOOTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:19:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5AC22211;
        Tue, 15 Sep 2020 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179377;
        bh=g/ZbVp3gFIHqVMhtI6f2AuOJ8RFTxxibUkVrVntdm/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjsjSQRf38b8lEwh5f8xb/oFKUJ4gxcKoJGKjhJCEoxovVIZdnilUMsT+m13LQxPJ
         512eBhe9gmvF3aFrz1Td4vXC5NVS/4K200Y3uQQHruUHDXTa4tMh67B/2nLHQcIX4s
         kV7LBbFnHDeYdqVOLL11uJCwlyxxe9rA+j1Cv3F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/78] iio: adc: mcp3422: fix locking on error path
Date:   Tue, 15 Sep 2020 16:12:34 +0200
Message-Id: <20200915140634.010489871@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Compagnucci <angelo.compagnucci@gmail.com>

[ Upstream commit a139ffa40f0c24b753838b8ef3dcf6ad10eb7854 ]

Reading from the chip should be unlocked on error path else the lock
could never being released.

Fixes: 07914c84ba30 ("iio: adc: Add driver for Microchip MCP3422/3/4 high resolution ADC")
Fixes: 3f1093d83d71 ("iio: adc: mcp3422: fix locking scope")
Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Angelo Compagnucci <angelo.compagnucci@gmail.com>
Link: https://lore.kernel.org/r/20200901093218.1500845-1-angelo.compagnucci@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mcp3422.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/mcp3422.c b/drivers/iio/adc/mcp3422.c
index 819f260115005..a5a687257c0b8 100644
--- a/drivers/iio/adc/mcp3422.c
+++ b/drivers/iio/adc/mcp3422.c
@@ -148,8 +148,10 @@ static int mcp3422_read_channel(struct mcp3422 *adc,
 		config &= ~MCP3422_PGA_MASK;
 		config |= MCP3422_PGA_VALUE(adc->pga[req_channel]);
 		ret = mcp3422_update_config(adc, config);
-		if (ret < 0)
+		if (ret < 0) {
+			mutex_unlock(&adc->lock);
 			return ret;
+		}
 		msleep(mcp3422_read_times[MCP3422_SAMPLE_RATE(adc->config)]);
 	}
 
-- 
2.25.1



