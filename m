Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F3B4699F6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345613AbhLFPEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:04:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36446 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbhLFPDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:03:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F08CB8101C;
        Mon,  6 Dec 2021 15:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29D9C341C2;
        Mon,  6 Dec 2021 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802808;
        bh=q+lCINyGqzQDugpdsbuqLQaElSDxcAT/cRASUeJ7XHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvEkZrJ0rG20BWbIFfp1KtRe/KJc7fgpkZJCnbv1LhF/HspfvKWEPcoxXr/fltXKv
         Si//MHknggPiQfSBEwMhKL0kFHvBbB98GmHth4gtNDgPUy/hwK8dJlWc1BIASgKqbO
         Idt0drnt2U2Z4PQufAQTdheCdqp8EQhFlN/grnE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Teng Qi <starmiku1207184332@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 40/52] net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()
Date:   Mon,  6 Dec 2021 15:56:24 +0100
Message-Id: <20211206145549.267799698@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Teng Qi <starmiku1207184332@gmail.com>

[ Upstream commit 0fa68da72c3be09e06dd833258ee89c33374195f ]

The definition of macro MOTO_SROM_BUG is:
  #define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(
  dev->dev_addr) & 0x00ffffff) == 0x3e0008)

and the if statement
  if (MOTO_SROM_BUG) lp->active = 0;

using this macro indicates lp->active could be 8. If lp->active is 8 and
the second comparison of this macro is false. lp->active will remain 8 in:
  lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
  lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
  lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].ttm = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].mci = *p;

However, the length of array lp->phy is 8, so array overflows can occur.
To fix these possible array overflows, we first check lp->active and then
return -EINVAL if it is greater or equal to ARRAY_SIZE(lp->phy) (i.e. 8).

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de4x5.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4701,6 +4701,10 @@ type3_infoblock(struct net_device *dev,
         lp->ibn = 3;
         lp->active = *p++;
 	if (MOTO_SROM_BUG) lp->active = 0;
+	/* if (MOTO_SROM_BUG) statement indicates lp->active could
+	 * be 8 (i.e. the size of array lp->phy) */
+	if (WARN_ON(lp->active >= ARRAY_SIZE(lp->phy)))
+		return -EINVAL;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;


