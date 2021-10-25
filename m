Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C800A43A0F7
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhJYTgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234924AbhJYTbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D4B60FDC;
        Mon, 25 Oct 2021 19:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190057;
        bh=Ps6lIDaXjSpwSIMUsGNCTVWdQiy/a2kNcif61VQEJsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuDYegUM34nfigY9WijNckLUtrkPDS8ye7kbMTB1vSGeH+Ytagl0cIvBgtIP+k3w+
         mXWa/jYswR3EXHlQEoEQI17YJDj9kO/R70TtcBSU0voaJKfSPNQH6YLFkUXHnA38Jy
         eCzdAsUAeBwwWcF00/GduvgbI6umocYMn2eF0S+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 23/58] can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv
Date:   Mon, 25 Oct 2021 21:14:40 +0200
Message-Id: <20211025190941.317000148@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit d9d52a3ebd284882f5562c88e55991add5d01586 upstream.

It will trigger UAF for rx_kref of j1939_priv as following.

        cpu0                                    cpu1
j1939_sk_bind(socket0, ndev0, ...)
j1939_netdev_start
                                        j1939_sk_bind(socket1, ndev0, ...)
                                        j1939_netdev_start
j1939_priv_set
                                        j1939_priv_get_by_ndev_locked
j1939_jsk_add
.....
j1939_netdev_stop
kref_put_lock(&priv->rx_kref, ...)
                                        kref_get(&priv->rx_kref, ...)
                                        REFCOUNT_WARN("addition on 0;...")

====================================================
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 20874 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0
RIP: 0010:refcount_warn_saturate+0x169/0x1e0
Call Trace:
 j1939_netdev_start+0x68b/0x920
 j1939_sk_bind+0x426/0xeb0
 ? security_socket_bind+0x83/0xb0

The rx_kref's kref_get() and kref_put() should use j1939_netdev_lock to
protect.

Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/20210926104757.2021540-1-william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Reported-by: syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -249,11 +249,14 @@ struct j1939_priv *j1939_netdev_start(st
 	struct j1939_priv *priv, *priv_new;
 	int ret;
 
-	priv = j1939_priv_get_by_ndev(ndev);
+	spin_lock(&j1939_netdev_lock);
+	priv = j1939_priv_get_by_ndev_locked(ndev);
 	if (priv) {
 		kref_get(&priv->rx_kref);
+		spin_unlock(&j1939_netdev_lock);
 		return priv;
 	}
+	spin_unlock(&j1939_netdev_lock);
 
 	priv = j1939_priv_create(ndev);
 	if (!priv)
@@ -269,10 +272,10 @@ struct j1939_priv *j1939_netdev_start(st
 		/* Someone was faster than us, use their priv and roll
 		 * back our's.
 		 */
+		kref_get(&priv_new->rx_kref);
 		spin_unlock(&j1939_netdev_lock);
 		dev_put(ndev);
 		kfree(priv);
-		kref_get(&priv_new->rx_kref);
 		return priv_new;
 	}
 	j1939_priv_set(ndev, priv);


