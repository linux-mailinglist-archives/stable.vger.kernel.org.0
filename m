Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5F37CA59
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbhELQ3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234907AbhELQUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:20:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C0F61D93;
        Wed, 12 May 2021 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834373;
        bh=X7kW5XeS5iSsyQsOvlCif7BER4DQTsz13EwFSfoR8g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGl9QYGUB0MZ/HUBOt3HeapGiLyEI9D7K6q1g/ScrZnel9c+AWmR/DitdusVjLMLw
         EZHyEJyxgaMokDrYXBBCzNRjfIgBUtz5whUeXsZJVPEsEKp/0slhyG9VI9C1+OhaK4
         /H5ULYNK55W9fu8UjnEvs5LWsgjWA5qiqX1Q+U/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 484/601] cxgb4: Fix unintentional sign extension issues
Date:   Wed, 12 May 2021 16:49:21 +0200
Message-Id: <20210512144843.784341285@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit dd2c79677375c37f8f9f8d663eb4708495d595ef ]

The shifting of the u8 integers f->fs.nat_lip[] by 24 bits to
the left will be promoted to a 32 bit signed int and then
sign-extended to a u64. In the event that the top bit of the u8
is set then all then all the upper 32 bits of the u64 end up as
also being set because of the sign-extension. Fix this by
casting the u8 values to a u64 before the 24 bit left shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 83b46440408b..bde8494215c4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -174,31 +174,31 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 				      WORD_MASK, f->fs.nat_lip[15] |
 				      f->fs.nat_lip[14] << 8 |
 				      f->fs.nat_lip[13] << 16 |
-				      f->fs.nat_lip[12] << 24, 1);
+				      (u64)f->fs.nat_lip[12] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_SND_UNA_RAW_W + 1,
 				      WORD_MASK, f->fs.nat_lip[11] |
 				      f->fs.nat_lip[10] << 8 |
 				      f->fs.nat_lip[9] << 16 |
-				      f->fs.nat_lip[8] << 24, 1);
+				      (u64)f->fs.nat_lip[8] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_SND_UNA_RAW_W + 2,
 				      WORD_MASK, f->fs.nat_lip[7] |
 				      f->fs.nat_lip[6] << 8 |
 				      f->fs.nat_lip[5] << 16 |
-				      f->fs.nat_lip[4] << 24, 1);
+				      (u64)f->fs.nat_lip[4] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_SND_UNA_RAW_W + 3,
 				      WORD_MASK, f->fs.nat_lip[3] |
 				      f->fs.nat_lip[2] << 8 |
 				      f->fs.nat_lip[1] << 16 |
-				      f->fs.nat_lip[0] << 24, 1);
+				      (u64)f->fs.nat_lip[0] << 24, 1);
 		} else {
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG3_LEN_RAW_W,
 				      WORD_MASK, f->fs.nat_lip[3] |
 				      f->fs.nat_lip[2] << 8 |
 				      f->fs.nat_lip[1] << 16 |
-				      f->fs.nat_lip[0] << 24, 1);
+				      (u64)f->fs.nat_lip[0] << 25, 1);
 		}
 	}
 
@@ -208,25 +208,25 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 				      WORD_MASK, f->fs.nat_fip[15] |
 				      f->fs.nat_fip[14] << 8 |
 				      f->fs.nat_fip[13] << 16 |
-				      f->fs.nat_fip[12] << 24, 1);
+				      (u64)f->fs.nat_fip[12] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG2_PTR_RAW_W + 1,
 				      WORD_MASK, f->fs.nat_fip[11] |
 				      f->fs.nat_fip[10] << 8 |
 				      f->fs.nat_fip[9] << 16 |
-				      f->fs.nat_fip[8] << 24, 1);
+				      (u64)f->fs.nat_fip[8] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG2_PTR_RAW_W + 2,
 				      WORD_MASK, f->fs.nat_fip[7] |
 				      f->fs.nat_fip[6] << 8 |
 				      f->fs.nat_fip[5] << 16 |
-				      f->fs.nat_fip[4] << 24, 1);
+				      (u64)f->fs.nat_fip[4] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG2_PTR_RAW_W + 3,
 				      WORD_MASK, f->fs.nat_fip[3] |
 				      f->fs.nat_fip[2] << 8 |
 				      f->fs.nat_fip[1] << 16 |
-				      f->fs.nat_fip[0] << 24, 1);
+				      (u64)f->fs.nat_fip[0] << 24, 1);
 
 		} else {
 			set_tcb_field(adap, f, tid,
@@ -234,13 +234,13 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 				      WORD_MASK, f->fs.nat_fip[3] |
 				      f->fs.nat_fip[2] << 8 |
 				      f->fs.nat_fip[1] << 16 |
-				      f->fs.nat_fip[0] << 24, 1);
+				      (u64)f->fs.nat_fip[0] << 24, 1);
 		}
 	}
 
 	set_tcb_field(adap, f, tid, TCB_PDU_HDR_LEN_W, WORD_MASK,
 		      (dp ? (nat_lp[1] | nat_lp[0] << 8) : 0) |
-		      (sp ? (nat_fp[1] << 16 | nat_fp[0] << 24) : 0),
+		      (sp ? (nat_fp[1] << 16 | (u64)nat_fp[0] << 24) : 0),
 		      1);
 }
 
-- 
2.30.2



