Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F5012C8DF
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbfL2R6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387455AbfL2R6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5647D208C4;
        Sun, 29 Dec 2019 17:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642282;
        bh=rerkSZcjfKi5kp8anhuxWnmRlOlAsoe+s233C8rnPRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Es+QCEfIvY2iPsBTOvGZUkmyZz6PYttVn3SuAU+qtuzi0/O+pOttZ8g/qdlpedxHY
         wnsEuQlsEMi9IgEjd29LjcBWpqiM6c2TehP275rQKWCvAIKtzQfrarLJ09qIW1q7Bt
         cjr9GSGZyuSapkdw2kUwAHg3b7QmN548GMoSv/GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 375/434] can: flexcan: fix possible deadlock and out-of-order reception after wakeup
Date:   Sun, 29 Dec 2019 18:27:08 +0100
Message-Id: <20191229172726.970351486@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit e707180ae2df1c87e26ec7a6fd70d07483bde7fd upstream.

When suspending, and there is still CAN traffic on the interfaces the
flexcan immediately wakes the platform again. As it should :-). But it
throws this error msg:

[ 3169.378661] PM: noirq suspend of devices failed

On the way down to suspend the interface that throws the error message
calls flexcan_suspend() but fails to call flexcan_noirq_suspend(). That
means flexcan_enter_stop_mode() is called, but on the way out of suspend
the driver only calls flexcan_resume() and skips flexcan_noirq_resume(),
thus it doesn't call flexcan_exit_stop_mode(). This leaves the flexcan
in stop mode, and with the current driver it can't recover from this
even with a soft reboot, it requires a hard reboot.

This patch fixes the deadlock when using self wakeup, by calling
flexcan_exit_stop_mode() from flexcan_resume() instead of
flexcan_noirq_resume().

This also fixes another issue: CAN frames are received out-of-order in
first IRQ handler run after wakeup.

The problem is that the wakeup latency from frame reception to the IRQ
handler (where the CAN frames are sorted by timestamp) is much bigger
than the time stamp counter wrap around time. This means it's
impossible to sort the CAN frames by timestamp.

The reason is that the controller exits stop mode during noirq resume,
which means it receives frames immediately, but interrupt handling is
still not possible.

So exit stop mode during resume stage instead of noirq resume fixes this
issue.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.0
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1703,6 +1703,9 @@ static int __maybe_unused flexcan_resume
 		netif_start_queue(dev);
 		if (device_may_wakeup(device)) {
 			disable_irq_wake(dev->irq);
+			err = flexcan_exit_stop_mode(priv);
+			if (err)
+				return err;
 		} else {
 			err = pm_runtime_force_resume(device);
 			if (err)
@@ -1748,14 +1751,9 @@ static int __maybe_unused flexcan_noirq_
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
-	int err;
 
-	if (netif_running(dev) && device_may_wakeup(device)) {
+	if (netif_running(dev) && device_may_wakeup(device))
 		flexcan_enable_wakeup_irq(priv, false);
-		err = flexcan_exit_stop_mode(priv);
-		if (err)
-			return err;
-	}
 
 	return 0;
 }


