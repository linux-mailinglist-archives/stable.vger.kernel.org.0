Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8F635BE3F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbhDLI5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238996AbhDLIzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED8F76127A;
        Mon, 12 Apr 2021 08:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217675;
        bh=uxWhrvLsfG6a1PviJMUvVUC2CajiNLdihXsgRFpzYr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRKSqDTsIVIs/41uIAoldmB4FvOvRw4xnVNy5LrXabXZXUm6rlOpeN8xHCfNbHZjq
         vxVkaybEuRM/8GZdib8+Cwx9LZDK/YTWIN1VeLK7HsnO6RmjwcRlo5uOv65pa2yRrg
         6Azxo0zp1iUQ/Lalj6nU16tc4N3g4cMW05Jr5prs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 059/188] i40e: Fix sparse errors in i40e_txrx.c
Date:   Mon, 12 Apr 2021 10:39:33 +0200
Message-Id: <20210412084015.613735423@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

commit 12738ac4754ec92a6a45bf3677d8da780a1412b3 upstream.

Remove error handling through pointers. Instead use plain int
to return value from i40e_run_xdp(...).

Previously:
- sparse errors were produced during compilation:
i40e_txrx.c:2338 i40e_run_xdp() error: (-2147483647) too low for ERR_PTR
i40e_txrx.c:2558 i40e_clean_rx_irq() error: 'skb' dereferencing possible ERR_PTR()

- sk_buff* was used to return value, but it has never had valid
pointer to sk_buff. Returned value was always int handled as
a pointer.

Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Fixes: 2e6893123830 ("i40e: split XDP_TX tail and XDP_REDIRECT map flushing")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2187,8 +2187,7 @@ int i40e_xmit_xdp_tx_ring(struct xdp_buf
  * @rx_ring: Rx ring being processed
  * @xdp: XDP buffer containing the frame
  **/
-static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
-				    struct xdp_buff *xdp)
+static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
@@ -2227,7 +2226,7 @@ static struct sk_buff *i40e_run_xdp(stru
 	}
 xdp_out:
 	rcu_read_unlock();
-	return ERR_PTR(-result);
+	return result;
 }
 
 /**
@@ -2339,6 +2338,7 @@ static int i40e_clean_rx_irq(struct i40e
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	struct xdp_buff xdp;
+	int xdp_res = 0;
 
 #if (PAGE_SIZE < 8192)
 	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
@@ -2405,12 +2405,10 @@ static int i40e_clean_rx_irq(struct i40e
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
 #endif
-			skb = i40e_run_xdp(rx_ring, &xdp);
+			xdp_res = i40e_run_xdp(rx_ring, &xdp);
 		}
 
-		if (IS_ERR(skb)) {
-			unsigned int xdp_res = -PTR_ERR(skb);
-
+		if (xdp_res) {
 			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
 				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);


