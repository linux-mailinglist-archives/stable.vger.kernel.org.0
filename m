Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA293396289
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhEaO5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234095AbhEaOxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C978B61936;
        Mon, 31 May 2021 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469553;
        bh=1mNxDuzzYQ5c3jQGFmTrE83ZE0+KtLLBOnm8/X6TgSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSWfg1Uqiyxp7GhQkciwPueHnvbKD7HrX+gNUXurJ01cIH0KEWCwRzaVJP4/1buzE
         /hnt9XTzR+r4dkZ9iPIaM5poJPj4NNKmjz+mZzXhyKbE1Nx9UQ4CTZkjeIFsVPIX6h
         hd91EmIpQM1yZjyKM2dpJmtmRbyiSOIeBDuAvVOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <thomas.liu@ucloud.cn>,
        Ilya Maximets <i.maximets@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 240/296] openvswitch: meter: fix race when getting now_ms.
Date:   Mon, 31 May 2021 15:14:55 +0200
Message-Id: <20210531130711.866368692@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Liu <thomas.liu@ucloud.cn>

[ Upstream commit e4df1b0c24350a0f00229ff895a91f1072bd850d ]

We have observed meters working unexpected if traffic is 3+Gbit/s
with multiple connections.

now_ms is not pretected by meter->lock, we may get a negative
long_delta_ms when another cpu updated meter->used, then:
    delta_ms = (u32)long_delta_ms;
which will be a large value.

    band->bucket += delta_ms * band->rate;
then we get a wrong band->bucket.

OpenVswitch userspace datapath has fixed the same issue[1] some
time ago, and we port the implementation to kernel datapath.

[1] https://patchwork.ozlabs.org/project/openvswitch/patch/20191025114436.9746-1-i.maximets@ovn.org/

Fixes: 96fbc13d7e77 ("openvswitch: Add meter infrastructure")
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/meter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 15424d26e85d..ca3c37f2f1e6 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -611,6 +611,14 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	spin_lock(&meter->lock);
 
 	long_delta_ms = (now_ms - meter->used); /* ms */
+	if (long_delta_ms < 0) {
+		/* This condition means that we have several threads fighting
+		 * for a meter lock, and the one who received the packets a
+		 * bit later wins. Assuming that all racing threads received
+		 * packets at the same time to avoid overflow.
+		 */
+		long_delta_ms = 0;
+	}
 
 	/* Make sure delta_ms will not be too large, so that bucket will not
 	 * wrap around below.
-- 
2.30.2



