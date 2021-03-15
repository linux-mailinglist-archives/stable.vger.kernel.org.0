Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EE933B6E5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhCON7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhCON6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9148864F1A;
        Mon, 15 Mar 2021 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816683;
        bh=1O7DPwMACBX9Y6FQA21+rcoyO3J9Vp+pOkkJNgitLWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQbuPEWhBHqVNZ0XnIcm3LLhXSxEkczZeGJqbJ/AplYASYickUeMmjON+NwCK8Xqr
         KxHbf8TaqALl3HHpu+xhQa06+n1ub6aLHw7jI1cne3rZPVO7ouRg8C4jj5tFdUaFvH
         afIu+HUoGCsDk/IqCd2wsvlhrNPBAJ3qVC3DGmyg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 062/306] net: usb: qmi_wwan: allow qmimux add/del with master up
Date:   Mon, 15 Mar 2021 14:52:05 +0100
Message-Id: <20210315135509.747732429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Daniele Palmas <dnlplm@gmail.com>

commit 6c59cff38e66584ae3ac6c2f0cbd8d039c710ba7 upstream.

There's no reason for preventing the creation and removal
of qmimux network interfaces when the underlying interface
is up.

This makes qmi_wwan mux implementation more similar to the
rmnet one, simplifying userspace management of the same
logical interfaces.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Reported-by: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -396,13 +396,6 @@ static ssize_t add_mux_store(struct devi
 		goto err;
 	}
 
-	/* we don't want to modify a running netdev */
-	if (netif_running(dev->net)) {
-		netdev_err(dev->net, "Cannot change a running device\n");
-		ret = -EBUSY;
-		goto err;
-	}
-
 	ret = qmimux_register_device(dev->net, mux_id);
 	if (!ret) {
 		info->flags |= QMI_WWAN_FLAG_MUX;
@@ -432,13 +425,6 @@ static ssize_t del_mux_store(struct devi
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	/* we don't want to modify a running netdev */
-	if (netif_running(dev->net)) {
-		netdev_err(dev->net, "Cannot change a running device\n");
-		ret = -EBUSY;
-		goto err;
-	}
-
 	del_dev = qmimux_find_dev(dev, mux_id);
 	if (!del_dev) {
 		netdev_err(dev->net, "mux_id not present\n");


