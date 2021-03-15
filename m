Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF90A33B712
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhCON72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhCON5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A278C64F1A;
        Mon, 15 Mar 2021 13:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816667;
        bh=vFRmbBK0M2OQW8V+CUumkxqvezOiQ2jYY7POR7dYWI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BufZtyMunCfWmASNOkCFv8plXHMrrDdOyTKz9hUeD8ngcpDd7u1dnykk0F58pHwJY
         ZRN5zZewxj9kTS8Qt6FSiymCRIb8OG57ZamAllWU5OZpD9bOmGLeVwG66SkK3Wmoqj
         KPTu+RF8OoR+pDYuyWSZfYVsDD9fNnK+sgx9hlJE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 052/306] net: enetc: remove bogus write to SIRXIDR from enetc_setup_rxbdr
Date:   Mon, 15 Mar 2021 14:51:55 +0100
Message-Id: <20210315135509.408889744@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 96a5223b918c8b79270fc0fec235a7ebad459098 upstream.

The Station Interface Receive Interrupt Detect Register (SIRXIDR)
contains a 16-bit wide mask of 'interrupt detected' events for each ring
associated with a port. Bit i is write-1-to-clean for RX ring i.

I have no explanation whatsoever how this line of code came to be
inserted in the blamed commit. I checked the downstream versions of that
patch and none of them have it.

The somewhat comical aspect of it is that we're writing a binary number
to the SIRXIDR register, which is derived from enetc_bd_unused(rx_ring).
Since the RX rings have 512 buffer descriptors, we end up writing 511 to
this register, which is 0x1ff, so we are effectively clearing the
'interrupt detected' event for rings 0-8.

This register is not what is used for interrupt handling though - it
only provides a summary for the entire SI. The hardware provides one
separate Interrupt Detect Register per RX ring, which auto-clears upon
read. So there doesn't seem to be any adverse effect caused by this
bogus write.

There is, however, one reason why this should be handled as a bugfix:
next_to_clean _should_ be committed to hardware, just not to that
register, and this was obscuring the fact that it wasn't. This is fixed
in the next patch, and removing the bogus line now allows the fix patch
to be backported beyond that point.

Fixes: fd5736bf9f23 ("enetc: Workaround for MDIO register access issue")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1212,7 +1212,6 @@ static void enetc_setup_rxbdr(struct ene
 	rx_ring->idr = hw->reg + ENETC_SIRXIDR;
 
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
-	enetc_wr(hw, ENETC_SIRXIDR, rx_ring->next_to_use);
 
 	/* enable ring */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);


