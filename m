Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B16431EAA
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhJROFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234170AbhJROB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B545B613B3;
        Mon, 18 Oct 2021 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564579;
        bh=wl6BZ4CiyNR380+3hmLrpZ/UsCdaPZpusfSZCKKUSUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks/X0oINv4OS+jhdRhImf6b0BYI0uDULzNG1T6v94j7uVovKSSFzV/USIhSubjXJs
         WV2wZWkVg+yTT0mVLEnsN21vSZoAk/KrikyPh3mLvnlZZn6oxObj8fQ1Xejwwo8Xas
         e7O0NKJCNzRODC3t6o/WA9Tr1B4OjyA+A9ypKgFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 110/151] net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work
Date:   Mon, 18 Oct 2021 15:24:49 +0200
Message-Id: <20211018132344.249261516@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Ramadoss <arun.ramadoss@microchip.com>

commit ef1100ef20f29aec4e62abeccdb5bdbebba1e378 upstream.

When the ksz module is installed and removed using rmmod, kernel crashes
with null pointer dereferrence error. During rmmod, ksz_switch_remove
function tries to cancel the mib_read_workqueue using
cancel_delayed_work_sync routine and unregister switch from dsa.

During dsa_unregister_switch it calls ksz_mac_link_down, which in turn
reschedules the workqueue since mib_interval is non-zero.
Due to which queue executed after mib_interval and it tries to access
dp->slave. But the slave is unregistered in the ksz_switch_remove
function. Hence kernel crashes.

To avoid this crash, before canceling the workqueue, resetted the
mib_interval to 0.

v1 -> v2:
-Removed the if condition in ksz_mib_read_work

Fixes: 469b390e1ba3 ("net: dsa: microchip: use delayed_work instead of timer + work")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -449,8 +449,10 @@ EXPORT_SYMBOL(ksz_switch_register);
 void ksz_switch_remove(struct ksz_device *dev)
 {
 	/* timer started */
-	if (dev->mib_read_interval)
+	if (dev->mib_read_interval) {
+		dev->mib_read_interval = 0;
 		cancel_delayed_work_sync(&dev->mib_read);
+	}
 
 	dev->dev_ops->exit(dev);
 	dsa_unregister_switch(dev->ds);


