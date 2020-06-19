Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB16F201142
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404919AbgFSPjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393678AbgFSP3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C92C821BE5;
        Fri, 19 Jun 2020 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580550;
        bh=vDYeOeZw0PbzjHe+DvTd+JnGhs4qgQVlU0CF/8kKTVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkNvPOq2tK/SND3xu8iGTISi8J2RVnlCpxWJBEqzsTEzaAjBjddHSyjQUtqp2jFd5
         uZHPw2gXfgXjauXhyxJtwIl3eW3YO7v8H977HjaoovZm1SXH6EyfbukjKzrBL/7s7a
         +tw9dVu1EC+2OIG1o5jdsAF1C/9fCtbztp4WXsuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.7 293/376] e1000e: Disable TSO for buffer overrun workaround
Date:   Fri, 19 Jun 2020 16:33:31 +0200
Message-Id: <20200619141724.210914719@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
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
@@ -5294,6 +5294,10 @@ static void e1000_watchdog_task(struct w
 					/* oops */
 					break;
 				}
+				if (hw->mac.type == e1000_pch_spt) {
+					netdev->features &= ~NETIF_F_TSO;
+					netdev->features &= ~NETIF_F_TSO6;
+				}
 			}
 
 			/* enable transmits in the hardware, need to do this


