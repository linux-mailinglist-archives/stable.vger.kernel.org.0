Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290EF395F25
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhEaOIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhEaOG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E874A61968;
        Mon, 31 May 2021 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468334;
        bh=Pk+wRoH3aM90NjcEyh2oeAkB7xg2RvR9VU9bhfGX9BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8MX6NuhNbnUWKFQ1HPQg7etYXILfo11dN38ZOm2bAixfXtpR0KlfMraHbX0yAjT+
         Ce06tBW/gyE1Uwt30EMYQ1iZFfasE+JCHv/cFe5ccLyPbl8Sox79XCxs02/po8ke69
         voQvXKfiHTA1b5jIrVKSK8AA2MtGgFRt7ehDpy80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <thomas.liu@ucloud.cn>,
        Ilya Maximets <i.maximets@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/252] openvswitch: meter: fix race when getting now_ms.
Date:   Mon, 31 May 2021 15:14:30 +0200
Message-Id: <20210531130704.982387840@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index 8fbefd52af7f..e594b4d6b58a 100644
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



