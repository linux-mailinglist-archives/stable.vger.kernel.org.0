Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8944F33B6B5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhCON6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhCON6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F0B64F16;
        Mon, 15 Mar 2021 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816679;
        bh=YnPNlty5rkvQMDxpLsfMXXWngIF8DjlwcEGFXjnavLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEOjrSb3oq11J9jcY+HOmNwS85oCDLm9L9ZlYtvLigkM4yZSiIvRoqTdS1MS+tNbd
         +pX4kQ81Hv7h00Cac44X6n8Yivi47erifita+F9liUxYFHSyj/qmAbinnTSUq0zBQP
         JAKbrglQ2NMBR3vaNqZ72EOEnbWbfdn26OMDadk4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 051/290] net: usb: qmi_wwan: allow qmimux add/del with master up
Date:   Mon, 15 Mar 2021 14:52:24 +0100
Message-Id: <20210315135543.648433161@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -419,13 +419,6 @@ static ssize_t add_mux_store(struct devi
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
@@ -455,13 +448,6 @@ static ssize_t del_mux_store(struct devi
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


