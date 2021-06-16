Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59CE3A9FA4
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhFPPjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235093AbhFPPic (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA786613DB;
        Wed, 16 Jun 2021 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857774;
        bh=gnIHSmiRm2ZA2eahi/RuH956Cu8q5rAqA8rv2HTFy0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmn2yIvKTKEgGucHfmfgpGOjN0Lh0Sar7bDcWY6A+bDsyD66rPszvSxO4vWQeBGp5
         Al2SHSZS9nWaHaKGUPnY5zMhQEeSQ9aWve8ljhv6alJ8zUFyjfHIhV3ivPi/qYd06a
         gugkr1n1e8sEvZV5OJMM9D2++qFzW1IB3FCkiTOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/38] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Wed, 16 Jun 2021 17:33:44 +0200
Message-Id: <20210616152836.507544876@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit a8db57c1d285c758adc7fb43d6e2bad2554106e1 ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error code
'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index eae8e87930cd..83894723ebee 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4842,8 +4842,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
 	if (err < 0)
 		goto errout;
 
-	if (!skb->len)
+	if (!skb->len) {
+		err = -EINVAL;
 		goto errout;
+	}
 
 	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
 	return 0;
-- 
2.30.2



