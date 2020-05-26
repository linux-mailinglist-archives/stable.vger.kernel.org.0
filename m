Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022481E2AA1
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389330AbgEZS5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389306AbgEZS5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:57:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15BA52086A;
        Tue, 26 May 2020 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519451;
        bh=HdsLc+/2oQmiq9OsPK83xe8aK/rkwX/OMi3Atsgxbpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aM4Cm8gmwbSmpRv/UIHTh67p+d7g+xziRv2BuEmKLQMinPTBidLsqMPLr4qVIGxgg
         BweXodbPM5q7UdlQ9NNmCjBDRtjsqD6GToa0HRTt0dXSd46Pkqy828+fJa8aRlRnTx
         hxH1XlhZsQ4G6KwaStse1r7PB2NMkTdNMFmZMp5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cao jin <caoj.fnst@cn.fujitsu.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 01/64] igb: use igb_adapter->io_addr instead of e1000_hw->hw_addr
Date:   Tue, 26 May 2020 20:52:30 +0200
Message-Id: <20200526183913.559071071@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cao jin <caoj.fnst@cn.fujitsu.com>

commit 629823b872402451b42462414da08dddd0e2c93d upstream.

When running as guest, under certain condition, it will oops as following.
writel() in igb_configure_tx_ring() results in oops, because hw->hw_addr
is NULL. While other register access won't oops kernel because they use
wr32/rd32 which have a defense against NULL pointer.

    [  141.225449] pcieport 0000:00:1c.0: AER: Multiple Uncorrected (Fatal)
    error received: id=0101
    [  141.225523] igb 0000:01:00.1: PCIe Bus Error:
    severity=Uncorrected (Fatal), type=Unaccessible,
    id=0101(Unregistered Agent ID)
    [  141.299442] igb 0000:01:00.1: broadcast error_detected message
    [  141.300539] igb 0000:01:00.0 enp1s0f0: PCIe link lost, device now
    detached
    [  141.351019] igb 0000:01:00.1 enp1s0f1: PCIe link lost, device now
    detached
    [  143.465904] pcieport 0000:00:1c.0: Root Port link has been reset
    [  143.465994] igb 0000:01:00.1: broadcast slot_reset message
    [  143.466039] igb 0000:01:00.0: enabling device (0000 -> 0002)
    [  144.389078] igb 0000:01:00.1: enabling device (0000 -> 0002)
    [  145.312078] igb 0000:01:00.1: broadcast resume message
    [  145.322211] BUG: unable to handle kernel paging request at
    0000000000003818
    [  145.361275] IP: [<ffffffffa02fd38d>]
    igb_configure_tx_ring+0x14d/0x280 [igb]
    [  145.400048] PGD 0
    [  145.438007] Oops: 0002 [#1] SMP

A similar issue & solution could be found at:
    http://patchwork.ozlabs.org/patch/689592/

Signed-off-by: Cao jin <caoj.fnst@cn.fujitsu.com>
Acked-by: Alexander Duyck <alexander.h.duyck@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/igb/igb_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3395,7 +3395,7 @@ void igb_configure_tx_ring(struct igb_ad
 	     tdba & 0x00000000ffffffffULL);
 	wr32(E1000_TDBAH(reg_idx), tdba >> 32);
 
-	ring->tail = hw->hw_addr + E1000_TDT(reg_idx);
+	ring->tail = adapter->io_addr + E1000_TDT(reg_idx);
 	wr32(E1000_TDH(reg_idx), 0);
 	writel(0, ring->tail);
 
@@ -3734,7 +3734,7 @@ void igb_configure_rx_ring(struct igb_ad
 	     ring->count * sizeof(union e1000_adv_rx_desc));
 
 	/* initialize head and tail */
-	ring->tail = hw->hw_addr + E1000_RDT(reg_idx);
+	ring->tail = adapter->io_addr + E1000_RDT(reg_idx);
 	wr32(E1000_RDH(reg_idx), 0);
 	writel(0, ring->tail);
 


