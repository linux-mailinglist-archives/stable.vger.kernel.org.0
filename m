Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC214DC12
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgA3NhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 08:37:02 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:11941 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgA3NhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 08:37:02 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2020 08:37:01 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580391420;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=D9/rKeaBEIa8g767m+jAx030F+M3BpeQII4qSughjjE=;
        b=gkTLrPJVI8+QK2EumZqarB0WW/KtdjFv9Wazulc/jtkWre9aC2Gh4QMZLak/0C/Nlu
        4HmmYKOJxlocDgaGCLTGpoZ/T7PHEW/AgRy9UdN+tfZQgQXGV/iwxZIaLMBnxAHHOJyk
        mqBzY0rFxcqmguNgI3AzZriyCp9X8LqNBbZYjefv/u9gMHqxCqNPK0+T2rkFTGdCUmLy
        B0sPaKfIrXM6pxnKIUm7MXUdqERh0IIq1G6/5ge7cbuDjKeOtZ9M0rkTuXVR+nf8mbCh
        Pcg14M0fuFHzqZ3Eq/kQlFfLrzNjXYpHErLTAwpYFci2nqjBuxEgVGWXjVSHvgnnEPRb
        Csgg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS8nvQfEUpxpWaP+a2CUQ=="
X-RZG-CLASS-ID: mo00
Received: from silver.be.tmme.com
        by smtp.strato.de (RZmta 46.1.12 AUTH)
        with ESMTPSA id g084e8w0UDV105S
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 30 Jan 2020 14:31:01 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, mkl@pengutronix.de, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH] bonding: do not enslave CAN devices
Date:   Thu, 30 Jan 2020 14:30:46 +0100
Message-Id: <20200130133046.2047-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
device struct can_dev_rcv_lists") the device specific CAN receive filter lists
are stored in netdev_priv() and dev->ml_priv points to these filters.

In the bug report Syzkaller enslaved a vxcan1 CAN device and accessed the
bonding device with a PF_CAN socket which lead to a crash due to an access of
an unhandled bond_dev->ml_priv pointer.

Deny to enslave CAN devices by the bonding driver as the resulting bond_dev
pretends to be a CAN device by copying dev->type without really being one.

Reported-by: syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com
Fixes: 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
device struct can_dev_rcv_lists")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 drivers/net/bonding/bond_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 48d5ec770b94..4b781a7dfd96 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1475,6 +1475,18 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		return -EPERM;
 	}
 
+	/* CAN network devices hold device specific filter lists in
+	 * netdev_priv() where dev->ml_priv sets a reference to.
+	 * As bonding assumes to have some ethernet-like device it doesn't
+	 * take care about these CAN specific filter lists today.
+	 * So we deny the enslaving of CAN interfaces here.
+	 */
+	if (slave_dev->type == ARPHRD_CAN) {
+		NL_SET_ERR_MSG(extack, "CAN devices can not be enslaved");
+		slave_err(bond_dev, slave_dev, "no bonding on CAN devices\n");
+		return -EINVAL;
+	}
+
 	/* set bonding device ether type by slave - bonding netdevices are
 	 * created with ether_setup, so when the slave type is not ARPHRD_ETHER
 	 * there is a need to override some of the type dependent attribs/funcs.
-- 
2.20.1

