Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E977273001
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgIURBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbgIUQio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:38:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7586F239D0;
        Mon, 21 Sep 2020 16:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706323;
        bh=Pzs6qruw76I/AzHcSJLll67dnrGP7d8pxzuN+iy4L2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3oHo03v9s4WV23ybSIuGQD7Hx9etmIO3QLa201Bi1UGf9bARG4FABtkU1kXBBTVR
         LZ8/xfpamRfrAv5BqCWctfKfHa7fCd9dNYxdW9gadDiTSXsPQYCrA9/36pwGivByJt
         koD+IAkC3unxciOg753pzSRUL2Fwh3zbvexXhdg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/94] iio: adc: mcp3422: fix locking on error path
Date:   Mon, 21 Sep 2020 18:27:11 +0200
Message-Id: <20200921162036.653636676@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 drivers/iio/adc/mcp3422.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/mcp3422.c
+++ b/drivers/iio/adc/mcp3422.c
@@ -146,8 +146,10 @@ static int mcp3422_read_channel(struct m
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
 


