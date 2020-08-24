Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E910624F917
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgHXIp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgHXIp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:45:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 719102072D;
        Mon, 24 Aug 2020 08:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258727;
        bh=gYZjOG+RhGYnfjsq3qWn7jd/mSGHDgkxsezz2+QisPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GB/U1vaYUK0SRd19hC6b5V6Hqu5fOMGr6o9IRul2ECYpncQl2m6zjdqh+Ez4UqShG
         GNErq4XKPR3U2jaxQosAbTfWAFBXAXzChdxm/esgO98jTY9L0GtULqqC5h7Df9Fukt
         auoVZRCTbb+T9exRiUtUs/wDo6sNIQMy28CwKUQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 024/107] can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated
Date:   Mon, 24 Aug 2020 10:29:50 +0200
Message-Id: <20200824082406.286863477@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit af804b7826350d5af728dca4715e473338fbd7e5 upstream.

This patch adds check to ensure that the struct net_device::ml_priv is
allocated, as it is used later by the j1939 stack.

The allocation is done by all mainline CAN network drivers, but when using
bond or team devices this is not the case.

Bail out if no ml_priv is allocated.

Reported-by: syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20200807105200.26441-4-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/j1939/socket.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -466,6 +466,14 @@ static int j1939_sk_bind(struct socket *
 			goto out_release_sock;
 		}
 
+		if (!ndev->ml_priv) {
+			netdev_warn_once(ndev,
+					 "No CAN mid layer private allocated, please fix your driver and use alloc_candev()!\n");
+			dev_put(ndev);
+			ret = -ENODEV;
+			goto out_release_sock;
+		}
+
 		priv = j1939_netdev_start(ndev);
 		dev_put(ndev);
 		if (IS_ERR(priv)) {


