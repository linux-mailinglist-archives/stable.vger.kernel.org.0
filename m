Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51412395CCE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhEaNiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232105AbhEaNfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D736144C;
        Mon, 31 May 2021 13:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467537;
        bh=VliTm5Omfb1FQ1MFvq7AlbAecyXYQOrR6hstGepmpu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDUy0pmcBnBRyfgHKXVEd0MQs4K9hsICPc7gNPbvW7I0U5reavRtlPgkM9KvP4m95
         YEaDGf0rVsmpzhJ0oos/tNCEteLfHNonwV675OBlynidR4ms0hzVuGl0XAT7ufzWLG
         BnYaM4DSFQOjaXJUy/w3uqJUFZ7s5t7Ld+o+7nGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <thomas.liu@ucloud.cn>,
        Ilya Maximets <i.maximets@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/116] openvswitch: meter: fix race when getting now_ms.
Date:   Mon, 31 May 2021 15:14:37 +0200
Message-Id: <20210531130643.553968554@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
index 5ea2471ffc03..9b0c54f0702c 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -464,6 +464,14 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
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



