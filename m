Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B227F201059
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404691AbgFSP3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404686AbgFSP3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544E220734;
        Fri, 19 Jun 2020 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580576;
        bh=61pORohPiWeZyY+dHqg22TWv4zbtArNyLSuNKbDcWpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ER9F1OMmg0uvzrCTLY1uWDurKepXv7RxzZNMyVNy5jQ5VB0kj8AcJ1oO21P/5e6EO
         GxlvGE2nPTzCqwbDUSUckbeE160enHBTiK3TWw/c5w+7RDAzoum15kPdzDKxC4944e
         eWqrnvKTGy5MOUbCx+PwlsSwxOFtvGYLK3+RCcLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.7 302/376] Bluetooth: hci_bcm: respect IRQ polarity from DT
Date:   Fri, 19 Jun 2020 16:33:40 +0200
Message-Id: <20200619141724.636538661@linuxfoundation.org>
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

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit b25e4df4a83e516efbdeeefb5b2d3e259639a56e upstream.

The IRQ polarity is be configured in bcm_setup_sleep(). Make the
configured value match what is in the DeviceTree.

Cc: stable@vger.kernel.org
Fixes: f25a96c8eb46 ("Bluetooth: hci_bcm: enable IRQ capability from devicetree")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_bcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1153,7 +1153,8 @@ static int bcm_of_probe(struct bcm_devic
 	device_property_read_u8_array(bdev->dev, "brcm,bt-pcm-int-params",
 				      bdev->pcm_int_params, 5);
 	bdev->irq = of_irq_get_byname(bdev->dev->of_node, "host-wakeup");
-
+	bdev->irq_active_low = irq_get_trigger_type(bdev->irq)
+			     & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_LEVEL_LOW);
 	return 0;
 }
 


