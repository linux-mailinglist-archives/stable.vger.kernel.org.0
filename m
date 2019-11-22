Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F31106D75
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbfKVLAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731013AbfKVLAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3940E20679;
        Fri, 22 Nov 2019 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420415;
        bh=lFx2rRdEIXn+jqFY622RjoZc/jkGHnSqXCd/YP8iTn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgyI9O7fX+uJyZy98q7zUnBxn9t982TeMbRja0TopLw+QNj+8CxZif5Te7hLS0nGJ
         A9/kBMjuLY4z8SdfYC7BrmfpRQKvPYj6lbWl0OMUJx51fTwEL0Xoc6SyLyd4e+iOhF
         mrdz63eU14iTWijDJLFqCIxWaNEdCN7riZJUQH5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomer Tayar <Tomer.Tayar@cavium.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/220] qed: Avoid implicit enum conversion in qed_ooo_submit_tx_buffers
Date:   Fri, 22 Nov 2019 11:27:44 +0100
Message-Id: <20191122100919.876265747@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 8fa74e3c49204bdf788d99ef71840490cccc210d ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/net/ethernet/qlogic/qed/qed_ll2.c:799:32: warning: implicit
conversion from enumeration type 'enum core_tx_dest' to different
enumeration type 'enum qed_ll2_tx_dest' [-Wenum-conversion]
                tx_pkt.tx_dest = p_ll2_conn->tx_dest;
                               ~ ~~~~~~~~~~~~^~~~~~~
1 warning generated.

Fix this by using a switch statement to convert between the enumerated
values since they are not 1 to 1, which matches how the rest of the
driver handles this conversion.

Link: https://github.com/ClangBuiltLinux/linux/issues/125
Suggested-by: Tomer Tayar <Tomer.Tayar@cavium.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Tomer Tayar <Tomer.Tayar@cavium.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 015de1e0addd6..2847509a183d0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -796,7 +796,18 @@ qed_ooo_submit_tx_buffers(struct qed_hwfn *p_hwfn,
 		tx_pkt.vlan = p_buffer->vlan;
 		tx_pkt.bd_flags = bd_flags;
 		tx_pkt.l4_hdr_offset_w = l4_hdr_offset_w;
-		tx_pkt.tx_dest = p_ll2_conn->tx_dest;
+		switch (p_ll2_conn->tx_dest) {
+		case CORE_TX_DEST_NW:
+			tx_pkt.tx_dest = QED_LL2_TX_DEST_NW;
+			break;
+		case CORE_TX_DEST_LB:
+			tx_pkt.tx_dest = QED_LL2_TX_DEST_LB;
+			break;
+		case CORE_TX_DEST_DROP:
+		default:
+			tx_pkt.tx_dest = QED_LL2_TX_DEST_DROP;
+			break;
+		}
 		tx_pkt.first_frag = first_frag;
 		tx_pkt.first_frag_len = p_buffer->packet_length;
 		tx_pkt.cookie = p_buffer;
-- 
2.20.1



