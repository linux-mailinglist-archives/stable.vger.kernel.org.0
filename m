Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A0D27C65F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgI2Lod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbgI2LoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29802206E5;
        Tue, 29 Sep 2020 11:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379862;
        bh=4zji7kO56KNjZJWuPPEOjuUOSyq/gsT+aV46e7NqiQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuf+FYW2zLzp6ojg0SU/htW2Bz7RCNLf/FoKLodfdwWHB2Iz/8bg8JaBmfr58LVHS
         d9u6Pa9fFtdH9+sQtfH8A7SwYrwu7yWfayXQDewu1LZOkErNNcZ++oUw5SMqxJJ299
         1MHpGd5Gj6blP3I1ekrM5WZl2NDfP3j9BEqPmX3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 320/388] net: openvswitch: use div_u64() for 64-by-32 divisions
Date:   Tue, 29 Sep 2020 13:00:51 +0200
Message-Id: <20200929110025.958627895@linuxfoundation.org>
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

[ Upstream commit 659d4587fe7233bfdff303744b20d6f41ad04362 ]

Compile the kernel for arm 32 platform, the build warning found.
To fix that, should use div_u64() for divisions.
| net/openvswitch/meter.c:396: undefined reference to `__udivdi3'

[add more commit msg, change reported tag, and use div_u64 instead
of do_div by Tonghao]

Fixes: e57358873bb5d6ca ("net: openvswitch: use u64 for meter bucket")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index b10734f18bbd6..541eea74ef7a6 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -252,7 +252,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		 * Start with a full bucket.
 		 */
 		band->bucket = (band->burst_size + band->rate) * 1000ULL;
-		band_max_delta_t = band->bucket / band->rate;
+		band_max_delta_t = div_u64(band->bucket, band->rate);
 		if (band_max_delta_t > meter->max_delta_t)
 			meter->max_delta_t = band_max_delta_t;
 		band++;
-- 
2.25.1



