Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC87200EF5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392239AbgFSPNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392202AbgFSPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96EA21919;
        Fri, 19 Jun 2020 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579598;
        bh=XtuQA8KOA/OYaIpFxAD4P9Jj8QgKracaOa8PA2ALPqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9wrmacqFr9MjH3eKz0UnXesSEAkqfnHwhgIn6l5LTdBzTw9oWJbPeNVv9uNV6exT
         Yx+wwZFO5gTv//RqgARklJHIFTrrDFfgJcIxZn1Brbo9KT6gne4uRoRc0M8B+ibwrw
         qEifUWed9Wn06z/3Fmkn2NHyf4E7E3XNC+oiuDlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.4 196/261] e1000e: Disable TSO for buffer overrun workaround
Date:   Fri, 19 Jun 2020 16:33:27 +0200
Message-Id: <20200619141659.288557733@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit f29801030ac67bf98b7a65d3aea67b30769d4f7c upstream.

Commit b10effb92e27 ("e1000e: fix buffer overrun while the I219 is
processing DMA transactions") imposes roughly 30% performance penalty.

The commit log states that "Disabling TSO eliminates performance loss
for TCP traffic without a noticeable impact on CPU performance", so
let's disable TSO by default to regain the loss.

CC: stable <stable@vger.kernel.org>
Fixes: b10effb92e27 ("e1000e: fix buffer overrun while the I219 is processing DMA transactions")
BugLink: https://bugs.launchpad.net/bugs/1802691
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5289,6 +5289,10 @@ static void e1000_watchdog_task(struct w
 					/* oops */
 					break;
 				}
+				if (hw->mac.type == e1000_pch_spt) {
+					netdev->features &= ~NETIF_F_TSO;
+					netdev->features &= ~NETIF_F_TSO6;
+				}
 			}
 
 			/* enable transmits in the hardware, need to do this


