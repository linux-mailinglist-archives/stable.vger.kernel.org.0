Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5832C0664
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgKWMab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgKWMaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:30:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41CA520888;
        Mon, 23 Nov 2020 12:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134628;
        bh=rkV3UzNeK1pClqYmLI3b20Cxx2M3Zmq1MQAzFFupsIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/ih4y5Cqnw4BbyumKoSwZodk0d6pggn1VZF33Tl21fDPW8MDaIbwG1U/hUzulmWD
         bwNSlxh4JYtjF3dcqPNBSEINyu3oAHiqO302w0oEpKFOnnrKdxS24e/QYFD3a4c46J
         3etK+/81TTydQbGsrfMIWE8UVE2iXu4Hbw9MvA5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 26/91] net: ftgmac100: Fix crash when removing driver
Date:   Mon, 23 Nov 2020 13:21:46 +0100
Message-Id: <20201123121810.590944952@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 3d5179458d22dc0b4fdc724e4bed4231a655112a ]

When removing the driver we would hit BUG_ON(!list_empty(&dev->ptype_specific))
in net/core/dev.c due to still having the NC-SI packet handler
registered.

 # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/unbind
  ------------[ cut here ]------------
  kernel BUG at net/core/dev.c:10254!
  Internal error: Oops - BUG: 0 [#1] SMP ARM
  CPU: 0 PID: 115 Comm: sh Not tainted 5.10.0-rc3-next-20201111-00007-g02e0365710c4 #46
  Hardware name: Generic DT based system
  PC is at netdev_run_todo+0x314/0x394
  LR is at cpumask_next+0x20/0x24
  pc : [<806f5830>]    lr : [<80863cb0>]    psr: 80000153
  sp : 855bbd58  ip : 00000001  fp : 855bbdac
  r10: 80c03d00  r9 : 80c06228  r8 : 81158c54
  r7 : 00000000  r6 : 80c05dec  r5 : 80c05d18  r4 : 813b9280
  r3 : 813b9054  r2 : 8122c470  r1 : 00000002  r0 : 00000002
  Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
  Control: 00c5387d  Table: 85514008  DAC: 00000051
  Process sh (pid: 115, stack limit = 0x7cb5703d)
 ...
  Backtrace:
  [<806f551c>] (netdev_run_todo) from [<80707eec>] (rtnl_unlock+0x18/0x1c)
   r10:00000051 r9:854ed710 r8:81158c54 r7:80c76bb0 r6:81158c10 r5:8115b410
   r4:813b9000
  [<80707ed4>] (rtnl_unlock) from [<806f5db8>] (unregister_netdev+0x2c/0x30)
  [<806f5d8c>] (unregister_netdev) from [<805a8180>] (ftgmac100_remove+0x20/0xa8)
   r5:8115b410 r4:813b9000
  [<805a8160>] (ftgmac100_remove) from [<805355e4>] (platform_drv_remove+0x34/0x4c)

Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20201117024448.1170761-1-joel@jms.id.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1884,6 +1884,8 @@ static int ftgmac100_probe(struct platfo
 	return 0;
 
 err_ncsi_dev:
+	if (priv->ndev)
+		ncsi_unregister_dev(priv->ndev);
 err_register_netdev:
 	ftgmac100_destroy_mdio(netdev);
 err_setup_mdio:
@@ -1904,6 +1906,8 @@ static int ftgmac100_remove(struct platf
 	netdev = platform_get_drvdata(pdev);
 	priv = netdev_priv(netdev);
 
+	if (priv->ndev)
+		ncsi_unregister_dev(priv->ndev);
 	unregister_netdev(netdev);
 
 	clk_disable_unprepare(priv->clk);


