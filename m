Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01C2F7AB8
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbhAOMxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387736AbhAOMfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED6D2371F;
        Fri, 15 Jan 2021 12:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714103;
        bh=l5VtkXtMu9krPHv6MBjrU/BJhCHUV69z+qQ4LPpChyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=me35RYdH/Ncg0jl0OP3e3+oetykIkdkdhhTd6EdTj36JHnShJ+sb2Ox/QKbAoFugP
         +CpJ+1R9CpwtT/xubUTVbTdZ1Q/BbjiNNK8/SS69x88HR2BEyWIJS+ROGdc5pgF5s7
         tSsIbx6qYFPPX7+aYg96uVaALQ6X5KkbWqJVQX9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 17/62] s390/qeth: fix L2 header access in qeth_l3_osa_features_check()
Date:   Fri, 15 Jan 2021 13:27:39 +0100
Message-Id: <20210115121959.239459241@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
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
@@ -2114,7 +2114,7 @@ static netdev_features_t qeth_l3_osa_fea
 						    struct net_device *dev,
 						    netdev_features_t features)
 {
-	if (qeth_get_ip_version(skb) != 4)
+	if (vlan_get_protocol(skb) != htons(ETH_P_IP))
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 	return qeth_features_check(skb, dev, features);
 }


