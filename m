Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58D6138E0
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfEDK1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfEDK1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E40F2085A;
        Sat,  4 May 2019 10:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965642;
        bh=B8JsXVskxkafTJQUaOveFYwhPevrBxRFNw+nTHpxvTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5gHUcpbLvl/meZX9PvBqg60SxNdOE14ujEfbJlf3w23VV4CW/KUkNBedBavB6ecO
         tTiMEjvMLLxD5GkeLH9i5h/QZ8aH2UQotVHv+IUEAU3yNrYt18YOP1G64uEGSrzYG+
         mWBPcX7eLOP1QSYRFx5vS0mRg7ZtQZu3LJ45IFoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 17/23] bnxt_en: Fix uninitialized variable usage in bnxt_rx_pkt().
Date:   Sat,  4 May 2019 12:25:19 +0200
Message-Id: <20190504102452.093390037@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 0b397b17a4120cb80f7bf89eb30587b3dd9b0d1d ]

In bnxt_rx_pkt(), if the driver encounters BD errors, it will recycle
the buffers and jump to the end where the uninitailized variable "len"
is referenced.  Fix it by adding a new jump label that will skip
the length update.  This is the most correct fix since the length
may not be valid when we get this type of error.

Fixes: 6a8788f25625 ("bnxt_en: add support for software dynamic interrupt moderation")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1584,7 +1584,7 @@ static int bnxt_rx_pkt(struct bnxt *bp,
 			netdev_warn(bp->dev, "RX buffer error %x\n", rx_err);
 			bnxt_sched_reset(bp, rxr);
 		}
-		goto next_rx;
+		goto next_rx_no_len;
 	}
 
 	len = le32_to_cpu(rxcmp->rx_cmp_len_flags_type) >> RX_CMP_LEN_SHIFT;
@@ -1665,12 +1665,13 @@ static int bnxt_rx_pkt(struct bnxt *bp,
 	rc = 1;
 
 next_rx:
-	rxr->rx_prod = NEXT_RX(prod);
-	rxr->rx_next_cons = NEXT_RX(cons);
-
 	cpr->rx_packets += 1;
 	cpr->rx_bytes += len;
 
+next_rx_no_len:
+	rxr->rx_prod = NEXT_RX(prod);
+	rxr->rx_next_cons = NEXT_RX(cons);
+
 next_rx_no_prod_no_len:
 	*raw_cons = tmp_raw_cons;
 


