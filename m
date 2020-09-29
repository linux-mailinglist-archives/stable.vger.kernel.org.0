Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F9127C864
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbgI2MBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729913AbgI2LkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07992208FE;
        Tue, 29 Sep 2020 11:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379606;
        bh=jIhQZwXP3VavhttXfmnocOIZi+wRX7HUe9ayE5xeqI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHdNJA+xS7AYYp/26dQEWu8AaomK0pSU8212dBPNvGjKO1n9Jg/0gXSYv0iE//OQw
         rmFelVO4L7zfkw/wjESxkxH5QqwKDwXHkskyRv5CxFOWeT5ocABVin6lzj/TaUJK8g
         a/tMOD6STK6cMquGQd5lslVrG7ypFwHDrVmZwucM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Andy Zhou <azhou@ovn.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 238/388] net: openvswitch: use u64 for meter bucket
Date:   Tue, 29 Sep 2020 12:59:29 +0200
Message-Id: <20200929110022.001138757@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit e57358873bb5d6caa882b9684f59140912b37dde ]

When setting the meter rate to 4+Gbps, there is an
overflow, the meters don't work as expected.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/meter.c | 2 +-
 net/openvswitch/meter.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 3323b79ff548d..b10734f18bbd6 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -251,7 +251,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		 *
 		 * Start with a full bucket.
 		 */
-		band->bucket = (band->burst_size + band->rate) * 1000;
+		band->bucket = (band->burst_size + band->rate) * 1000ULL;
 		band_max_delta_t = band->bucket / band->rate;
 		if (band_max_delta_t > meter->max_delta_t)
 			meter->max_delta_t = band_max_delta_t;
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index f645913870bd2..2e3fd6f1d7ebe 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -23,7 +23,7 @@ struct dp_meter_band {
 	u32 type;
 	u32 rate;
 	u32 burst_size;
-	u32 bucket; /* 1/1000 packets, or in bits */
+	u64 bucket; /* 1/1000 packets, or in bits */
 	struct ovs_flow_stats stats;
 };
 
-- 
2.25.1



