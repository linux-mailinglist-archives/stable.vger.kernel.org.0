Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6652C428EFC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbhJKNxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237762AbhJKNwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2620F60EB4;
        Mon, 11 Oct 2021 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960241;
        bh=8l+86mA8f/Pj/aaw1ZvtDnwOPQ/GdpXSPFXhN2VXvKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygckLMdT23Ln9D/qMBgvTjXemiRWnsWB4GbtXHBLWBYQiho5laxV0vChPLVJV+7Oj
         qL5j/CTUhFGbpGsYG2sP8FpAXy23SJV6+Uj9Lt98HMsOkhkdLrVa9jQExsixnQP5N7
         HMqGDut/Uocnl4sLUaCm7hnLcGGGpDNmoEA384Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Subject: [PATCH 5.4 26/52] phy: mdio: fix memory leak
Date:   Mon, 11 Oct 2021 15:45:55 +0200
Message-Id: <20211011134504.630661637@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit ca6e11c337daf7925ff8a2aac8e84490a8691905 ]

Syzbot reported memory leak in MDIO bus interface, the problem was in
wrong state logic.

MDIOBUS_ALLOCATED indicates 2 states:
	1. Bus is only allocated
	2. Bus allocated and __mdiobus_register() fails, but
	   device_register() was called

In case of device_register() has been called we should call put_device()
to correctly free the memory allocated for this device, but mdiobus_free()
calls just kfree(dev) in case of MDIOBUS_ALLOCATED state

To avoid this behaviour we need to set bus->state to MDIOBUS_UNREGISTERED
_before_ calling device_register(), because put_device() should be
called even in case of device_register() failure.

Link: https://lore.kernel.org/netdev/YVMRWNDZDUOvQjHL@shell.armlinux.org.uk/
Fixes: 46abc02175b3 ("phylib: give mdio buses a device tree presence")
Reported-and-tested-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/eceae1429fbf8fa5c73dd2a0d39d525aa905074d.1633024062.git.paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5bf06eac04ba..bec73f0640d0 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -385,6 +385,13 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	bus->dev.groups = NULL;
 	dev_set_name(&bus->dev, "%s", bus->id);
 
+	/* We need to set state to MDIOBUS_UNREGISTERED to correctly release
+	 * the device in mdiobus_free()
+	 *
+	 * State will be updated later in this function in case of success
+	 */
+	bus->state = MDIOBUS_UNREGISTERED;
+
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-- 
2.33.0



