Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E79261A9D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgIHShn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731335AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52C1B24056;
        Tue,  8 Sep 2020 15:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580113;
        bh=QKzB+BQH7gWb2XR4pFgCH/ZgeAkxRdRAeAtFijApm9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAI+zyw/1S84Eq+HrWgPfO2LUu8ZdadzqsO2fYiuylFe+sd6ljiVTySS0s0FLM7pQ
         qcbbwyc/uGD3iECqRcpmYXlKDTK/bEPUIBpnxXofQLNx36ga12tARj7xccjJxpGdcp
         ZmpuB1R1o7Iw4jSZIz8SJh/XOUSzNX6hztP7lgRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Sherwood <rsher@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/88] bnxt: dont enable NAPI until rings are ready
Date:   Tue,  8 Sep 2020 17:25:37 +0200
Message-Id: <20200908152222.913469015@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 96ecdcc992eb7f468b2cf829b0f5408a1fad4668 ]

Netpoll can try to poll napi as soon as napi_enable() is called.
It crashes trying to access a doorbell which is still NULL:

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 CPU: 59 PID: 6039 Comm: ethtool Kdump: loaded Tainted: G S                5.9.0-rc1-00469-g5fd99b5d9950-dirty #26
 RIP: 0010:bnxt_poll+0x121/0x1c0
 Code: c4 20 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 8b 86 a0 01 00 00 41 23 85 18 01 00 00 49 8b 96 a8 01 00 00 0d 00 00 00 24 <89> 02
41 f6 45 77 02 74 cb 49 8b ae d8 01 00 00 31 c0 c7 44 24 1a
  netpoll_poll_dev+0xbd/0x1a0
  __netpoll_send_skb+0x1b2/0x210
  netpoll_send_udp+0x2c9/0x406
  write_ext_msg+0x1d7/0x1f0
  console_unlock+0x23c/0x520
  vprintk_emit+0xe0/0x1d0
  printk+0x58/0x6f
  x86_vector_activate.cold+0xf/0x46
  __irq_domain_activate_irq+0x50/0x80
  __irq_domain_activate_irq+0x32/0x80
  __irq_domain_activate_irq+0x32/0x80
  irq_domain_activate_irq+0x25/0x40
  __setup_irq+0x2d2/0x700
  request_threaded_irq+0xfb/0x160
  __bnxt_open_nic+0x3b1/0x750
  bnxt_open_nic+0x19/0x30
  ethtool_set_channels+0x1ac/0x220
  dev_ethtool+0x11ba/0x2240
  dev_ioctl+0x1cf/0x390
  sock_do_ioctl+0x95/0x130

Reported-by: Rob Sherwood <rsher@fb.com>
Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index df3514503dee9..a267380b267d7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7027,15 +7027,15 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 		}
 	}
 
-	bnxt_enable_napi(bp);
-	bnxt_debug_dev_init(bp);
-
 	rc = bnxt_init_nic(bp, irq_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
-		goto open_err;
+		goto open_err_irq;
 	}
 
+	bnxt_enable_napi(bp);
+	bnxt_debug_dev_init(bp);
+
 	if (link_re_init) {
 		mutex_lock(&bp->link_lock);
 		rc = bnxt_update_phy_setting(bp);
@@ -7066,10 +7066,6 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 		bnxt_vf_reps_open(bp);
 	return 0;
 
-open_err:
-	bnxt_debug_dev_exit(bp);
-	bnxt_disable_napi(bp);
-
 open_err_irq:
 	bnxt_del_napi(bp);
 
-- 
2.25.1



