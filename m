Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71894F7B2C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKKSdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbfKKSdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:33:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B736521655;
        Mon, 11 Nov 2019 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497196;
        bh=ffjaODsYTvbGyDYsiW9Bkd7LaAZfNiZXUzp88mmNdBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuOaGUDvDAD0hJEnvrpC6M5U1qL1gEoedQzQk5KKUxZIzhfKk1fi27TZDmgs4B5lN
         XM5GO1+/ytYgOEPxtinCGCAfZEPFMgftoXy/yccaARu/yevCwFqfZjQ+V+m4QCADmb
         +XNfLlQEgleWWTipw/kRoOJiassVUEs4YwAmMA/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nobuo Iwata <nobuo.iwata@fujixerox.co.jp>
Subject: [PATCH 4.9 35/65] usbip: fix possibility of dereference by NULLL pointer in vhci_hcd.c
Date:   Mon, 11 Nov 2019 19:28:35 +0100
Message-Id: <20191111181346.989434977@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuo Iwata <nobuo.iwata@fujixerox.co.jp>

commit d79cda045e3bacb7e754a5324cd3d4ce80708eb1 upstream.

This patch fixes possibility of dereference by NULLL pointer in "[PATCH
v5 1/3] usbip: vhci extension: modifications to vhci driver" which has
been merged to 4.9-rc1. It occurs when a URB with pointer to invalid
USB/IP device is enqueued in race condition against detach operation.

A pointer was passed to vdev_to_vhci() before NULL check.
In vdev_to_vhci(), there's a dereference by the pointer.

This patch moves vdev_to_vhci() after NULL check of the pointer.

Signed-off-by: Nobuo Iwata <nobuo.iwata@fujixerox.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/vhci_hcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -465,13 +465,14 @@ static void vhci_tx_urb(struct urb *urb)
 {
 	struct vhci_device *vdev = get_vdev(urb->dev);
 	struct vhci_priv *priv;
-	struct vhci_hcd *vhci = vdev_to_vhci(vdev);
+	struct vhci_hcd *vhci;
 	unsigned long flags;
 
 	if (!vdev) {
 		pr_err("could not get virtual device");
 		return;
 	}
+	vhci = vdev_to_vhci(vdev);
 
 	priv = kzalloc(sizeof(struct vhci_priv), GFP_ATOMIC);
 	if (!priv) {


