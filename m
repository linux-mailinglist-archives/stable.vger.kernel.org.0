Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6004528B84C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390175AbgJLNvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731833AbgJLNsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B8D2065C;
        Mon, 12 Oct 2020 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510427;
        bh=IVcKn/xg/ycW/BBex87+CC6Jg42D8JVex1qnazlGCjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=re26aubDdeohGEUMJ0EsJmIth9+Mm0URrqlEJKEJ3NVPlN5EIYMTllPyWgD4OI7FA
         CLLY5mZ9alxJznYn3s7wOz2v6OjIAaUKemYEOUfQcYFm+pQNRYtwBMFy73JrIzFo7u
         vi6ifGM6llY5dqLQ21zWruJMezrr2qAy8mKyd42s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Bin Luo <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        Zhao Chen <zhaochen6@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 095/124] net: hinic: fix DEVLINK build errors
Date:   Mon, 12 Oct 2020 15:31:39 +0200
Message-Id: <20201012133151.453231240@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1f7e877c20517735bceff1535e1b7fa846b2f215 ]

Fix many (lots deleted here) build errors in hinic by selecting NET_DEVLINK.

ld: drivers/net/ethernet/huawei/hinic/hinic_hw_dev.o: in function `mgmt_watchdog_timeout_event_handler':
hinic_hw_dev.c:(.text+0x30a): undefined reference to `devlink_health_report'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_fw_reporter_dump':
hinic_devlink.c:(.text+0x1c): undefined reference to `devlink_fmsg_u32_pair_put'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_fw_reporter_dump':
hinic_devlink.c:(.text+0x126): undefined reference to `devlink_fmsg_binary_pair_put'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_hw_reporter_dump':
hinic_devlink.c:(.text+0x1ba): undefined reference to `devlink_fmsg_string_pair_put'
ld: hinic_devlink.c:(.text+0x227): undefined reference to `devlink_fmsg_u8_pair_put'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_alloc':
hinic_devlink.c:(.text+0xaee): undefined reference to `devlink_alloc'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_free':
hinic_devlink.c:(.text+0xb04): undefined reference to `devlink_free'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_register':
hinic_devlink.c:(.text+0xb26): undefined reference to `devlink_register'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_unregister':
hinic_devlink.c:(.text+0xb46): undefined reference to `devlink_unregister'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_health_reporters_create':
hinic_devlink.c:(.text+0xb75): undefined reference to `devlink_health_reporter_create'
ld: hinic_devlink.c:(.text+0xb95): undefined reference to `devlink_health_reporter_create'
ld: hinic_devlink.c:(.text+0xbac): undefined reference to `devlink_health_reporter_destroy'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_health_reporters_destroy':

Fixes: 51ba902a16e6 ("net-next/hinic: Initialize hw interface")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Bin Luo <luobin9@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Aviad Krawczyk <aviad.krawczyk@huawei.com>
Cc: Zhao Chen <zhaochen6@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/huawei/hinic/Kconfig b/drivers/net/ethernet/huawei/hinic/Kconfig
index 936e2dd3bb135..b47bd5440c5f0 100644
--- a/drivers/net/ethernet/huawei/hinic/Kconfig
+++ b/drivers/net/ethernet/huawei/hinic/Kconfig
@@ -6,6 +6,7 @@
 config HINIC
 	tristate "Huawei Intelligent PCIE Network Interface Card"
 	depends on (PCI_MSI && (X86 || ARM64))
+	select NET_DEVLINK
 	help
 	  This driver supports HiNIC PCIE Ethernet cards.
 	  To compile this driver as part of the kernel, choose Y here.
-- 
2.25.1



