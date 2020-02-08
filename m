Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC4C15670C
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgBHS3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33464 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727546AbgBHS3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:33 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrC-0003Zu-Cm; Sat, 08 Feb 2020 18:29:30 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CIq-Cx; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Giuseppe CAVALLARO" <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Alexandre TORGUE" <alexandre.torgue@st.com>
Date:   Sat, 08 Feb 2020 18:19:05 +0000
Message-ID: <lsq.1581185940.672100138@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 006/148] stmmac: fix oversized frame reception
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>

commit e527c4a769d375ac0472450c52bde29087f49cd9 upstream.

The receive skb buffers can be preallocated when the link is opened
according to mtu size.
While testing on a network environment with not standard MTU (e.g. 3000),
a panic occurred if an incoming packet had a length greater than rx skb
buffer size. This is because the HW is programmed to copy, from the DMA,
an Jumbo frame and the Sw must check if the allocated buffer is enough to
store the frame.

Signed-off-by: Alexandre TORGUE <alexandre.torgue@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2120,6 +2120,12 @@ static int stmmac_rx(struct stmmac_priv
 
 			frame_len = priv->hw->desc->get_rx_frame_len(p, coe);
 
+			/*  check if frame_len fits the preallocated memory */
+			if (frame_len > priv->dma_buf_sz) {
+				priv->dev->stats.rx_length_errors++;
+				break;
+			}
+
 			/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
 			 * Type frames (LLC/LLC-SNAP)
 			 */

