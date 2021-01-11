Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8161E2F13B9
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbhAKNNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:13:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731998AbhAKNNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B90C2253A;
        Mon, 11 Jan 2021 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370814;
        bh=9DT0OLOL1Sae2kQnMggXLcorwQc2ktDj8rjbEQ4k8MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOGnYjMcnCT25BAvAL6gk1iE5UzmmG3JeAMKkGR15uui3QihUpqrbMIzjlB91LrFy
         V3LjzxeVOssWBOjBIzurjcbMUCKbx2G7S33tosK8HBRu/AekMf1pha5ecWefoN4s56
         p5+IvNTXaZLGhrWH6SxpT2Vg0e2JhRI3VaIf5Scg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 016/145] qede: fix offload for IPIP tunnel packets
Date:   Mon, 11 Jan 2021 14:00:40 +0100
Message-Id: <20210111130049.293206480@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 5d5647dad259bb416fd5d3d87012760386d97530 ]

IPIP tunnels packets are unknown to device,
hence these packets are incorrectly parsed and
caused the packet corruption, so disable offlods
for such packets at run time.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Link: https://lore.kernel.org/r/20201221145530.7771-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1799,6 +1799,11 @@ netdev_features_t qede_features_check(st
 			      ntohs(udp_hdr(skb)->dest) != gnv_port))
 				return features & ~(NETIF_F_CSUM_MASK |
 						    NETIF_F_GSO_MASK);
+		} else if (l4_proto == IPPROTO_IPIP) {
+			/* IPIP tunnels are unknown to the device or at least unsupported natively,
+			 * offloads for them can't be done trivially, so disable them for such skb.
+			 */
+			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 		}
 	}
 


