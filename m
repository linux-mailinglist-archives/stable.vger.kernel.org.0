Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF72F7A42
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387964AbhAOMhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387959AbhAOMhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F4723339;
        Fri, 15 Jan 2021 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714228;
        bh=57S0cVgSHYpt7+WGqQ9pdhsZ6+BrOrWTTWGe4ODaIDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xzft8PI1RNHyRy1Qkd5dlw8K5jtIehaHSYy4MmfqFDRne0HXye3+SLcTW5O6TZ4SO
         WD0eWF6zsKhESDfh+0BDto7MFEa9ayu4xuikmtuMkTcqNmRXUSjMOMy6fQ95PoBvnn
         wIOozK8Ijb4v9L5gMHuF51Onn/fmjuN+D1146wao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 042/103] s390/qeth: fix L2 header access in qeth_l3_osa_features_check()
Date:   Fri, 15 Jan 2021 13:27:35 +0100
Message-Id: <20210115122008.093077422@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit f9c4845385c8f6631ebd5dddfb019ea7a285fba4 ]

ip_finish_output_gso() may call .ndo_features_check() even before the
skb has a L2 header. This conflicts with qeth_get_ip_version()'s attempt
to inspect the L2 header via vlan_eth_hdr().

Switch to vlan_get_protocol(), as already used further down in the
common qeth_features_check() path.

Fixes: f13ade199391 ("s390/qeth: run non-offload L3 traffic over common xmit path")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_l3_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1816,7 +1816,7 @@ static netdev_features_t qeth_l3_osa_fea
 						    struct net_device *dev,
 						    netdev_features_t features)
 {
-	if (qeth_get_ip_version(skb) != 4)
+	if (vlan_get_protocol(skb) != htons(ETH_P_IP))
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 	return qeth_features_check(skb, dev, features);
 }


