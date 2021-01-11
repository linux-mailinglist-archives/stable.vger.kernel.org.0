Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8952F15FF
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbhAKNK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731189AbhAKNK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7E1621534;
        Mon, 11 Jan 2021 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370613;
        bh=M8TOvm/1aI6Vfwo95DF783lJLCnR4hOJfYcFuxNG9Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVa2B2aygcEKBS11EkjurYVKvnSuP/sQow0HucNPEgZ1LA7ND5dXLDmocSkZD30HI
         R9w0D428pvI/nOF3v4GYWDlODImaPjp5uIZ6sN7VHe2G55e9oob8AjycXiLTFuuooW
         3POjGT9rWZmccuDL2lI/ljoZmZprSaF9Kd+4E/qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 21/92] qede: fix offload for IPIP tunnel packets
Date:   Mon, 11 Jan 2021 14:01:25 +0100
Message-Id: <20210111130040.167867195@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
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
@@ -1737,6 +1737,11 @@ netdev_features_t qede_features_check(st
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
 


