Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6611342DC8C
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhJNO75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232562AbhJNO67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15B9660F4A;
        Thu, 14 Oct 2021 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223414;
        bh=SFHbF9fMm8RbgxadZvNqvrApORzyb/26Zm5ZEtBiPe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A82AsXqzqFhQ7NzVkN3TSh39gv/qFA8r9WMQ6UBvOMJtY4i1hMhEft/dppp99e8Mn
         kLfStZW0WbfP6DanWSL5Ks1uzXJcCxT+dYVu6fHswvzY48LMEfCsz1VtKTvN2ip0HR
         n3Vfh0QkuTnXaP3R1ugbHjx7Tk64LbcpSlHqfvd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Subject: [PATCH 4.14 13/33] phy: mdio: fix memory leak
Date:   Thu, 14 Oct 2021 16:53:45 +0200
Message-Id: <20211014145209.222914468@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
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
index 5fc7b6c1a442..5ef9bbbab3db 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -344,6 +344,13 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
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



