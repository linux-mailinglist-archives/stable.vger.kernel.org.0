Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045F335BFB6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbhDLJG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239783AbhDLJEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E36561371;
        Mon, 12 Apr 2021 09:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218085;
        bh=0RWwTbYRAvktvVLW2GK7FwSdicZ4RkYmOUQFYj2dO/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNX4x7Yex9gwWp6GV+FBNm5swCa7dda7A3gG4+Z64ubzZ++fuJdKatyJVzLooHB9S
         FF766pk3kMIOu4iEr1jmAR1/epsRa9DzXne42vAzZKFyHpRJHIVt6iroFZbh3TJplG
         4JfVwZatgn+G67m+i/frMjC+Gy/Ki3fQr7PwQ60s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 066/210] i40e: Fix sparse errors in i40e_txrx.c
Date:   Mon, 12 Apr 2021 10:39:31 +0200
Message-Id: <20210412084018.199325285@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
@@ -2198,8 +2198,7 @@ int i40e_xmit_xdp_tx_ring(struct xdp_buf
  * @rx_ring: Rx ring being processed
  * @xdp: XDP buffer containing the frame
  **/
-static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
-				    struct xdp_buff *xdp)
+static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
@@ -2238,7 +2237,7 @@ static struct sk_buff *i40e_run_xdp(stru
 	}
 xdp_out:
 	rcu_read_unlock();
-	return ERR_PTR(-result);
+	return result;
 }
 
 /**
@@ -2350,6 +2349,7 @@ static int i40e_clean_rx_irq(struct i40e
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	struct xdp_buff xdp;
+	int xdp_res = 0;
 
 #if (PAGE_SIZE < 8192)
 	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
@@ -2416,12 +2416,10 @@ static int i40e_clean_rx_irq(struct i40e
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


