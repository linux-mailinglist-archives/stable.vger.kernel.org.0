Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E07177F47
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbgCCRtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbgCCRtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4492146E;
        Tue,  3 Mar 2020 17:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257784;
        bh=4ISSmUk3GQEPzgk7PG6P3uUSjVVpssrs3uevj0Z/Es0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0tVnCthiY+bpvlCZcWi3Rg+k7I4vC+1FW0KYjxF1nGHgtSD3+EsrvPLm3nDshL1v
         GVtWILjnpeeTZiuRWb7eSlgy91VomxSLE9cvrZajGX6L5Z4ik/YGG7n+cFYOYtpbaQ
         SvTgGGGUqdw48Kd23ixW+Z8MIXoRE0Di8/9vl82w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 127/176] net: atlantic: checksum compat issue
Date:   Tue,  3 Mar 2020 18:43:11 +0100
Message-Id: <20200303174319.445748656@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bezrukov <dbezrukov@marvell.com>

commit 15beab0a9d797be1b7c67458da007a62269be29a upstream.

Yet another checksum offload compatibility issue was found.

The known issue is that AQC HW marks tcp packets with 0xFFFF checksum
as invalid (1). This is workarounded in driver, passing all the suspicious
packets up to the stack for further csum validation.

Another HW problem (2) is that it hides invalid csum of LRO aggregated
packets inside of the individual descriptors. That was workarounded
by forced scan of all LRO descriptors for checksum errors.

However the scan logic was joint for both LRO and multi-descriptor
packets (jumbos). And this causes the issue.

We have to drop LRO packets with the detected bad checksum
because of (2), but we have to pass jumbo packets to stack because of (1).

When using windows tcp partner with jumbo frames but with LSO disabled
driver discards such frames as bad checksummed. But only LRO frames
should be dropped, not jumbos.

On such a configurations tcp stream have a chance of drops and stucks.

(1) 76f254d4afe2 ("net: aquantia: tcp checksum 0xffff being handled incorrectly")
(2) d08b9a0a3ebd ("net: aquantia: do not pass lro session with invalid tcp checksum")

Fixes: d08b9a0a3ebd ("net: aquantia: do not pass lro session with invalid tcp checksum")
Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c          |    3 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h          |    3 ++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |    5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -351,7 +351,8 @@ int aq_ring_rx_clean(struct aq_ring_s *s
 				err = 0;
 				goto err_exit;
 			}
-			if (buff->is_error || buff->is_cso_err) {
+			if (buff->is_error ||
+			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
 				do {
 					next_ = buff_->next,
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -78,7 +78,8 @@ struct __packed aq_ring_buff_s {
 			u32 is_cleaned:1;
 			u32 is_error:1;
 			u32 is_vlan:1;
-			u32 rsvd3:4;
+			u32 is_lro:1;
+			u32 rsvd3:3;
 			u16 eop_index;
 			u16 rsvd4;
 		};
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -823,6 +823,8 @@ static int hw_atl_b0_hw_ring_rx_receive(
 			}
 		}
 
+		buff->is_lro = !!(HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
+				  rxd_wb->status);
 		if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
 			buff->len = rxd_wb->pkt_len %
 				AQ_CFG_RX_FRAME_MAX;
@@ -835,8 +837,7 @@ static int hw_atl_b0_hw_ring_rx_receive(
 				rxd_wb->pkt_len > AQ_CFG_RX_FRAME_MAX ?
 				AQ_CFG_RX_FRAME_MAX : rxd_wb->pkt_len;
 
-			if (HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
-				rxd_wb->status) {
+			if (buff->is_lro) {
 				/* LRO */
 				buff->next = rxd_wb->next_desc_ptr;
 				++ring->stats.rx.lro_packets;


