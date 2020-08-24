Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CB724F9C1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHXJtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbgHXIkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:40:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B234B22B49;
        Mon, 24 Aug 2020 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258414;
        bh=gYZjOG+RhGYnfjsq3qWn7jd/mSGHDgkxsezz2+QisPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQcTvgZniksxZrM7RaQfDdIA5tTRP9DAINnE+3vcZnTcCae68bpODAcffmfKPLhiX
         rzsocn3a9McLmJ2alEAQo5cz/rdDTYiNpMM+pqP/r6LLEFGOCpTbDRhM+X2pyPjwXj
         e8aPpImy4nguYt9aCCfbUE86CbZ1L7NvT+NxERK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.7 009/124] can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated
Date:   Mon, 24 Aug 2020 10:29:03 +0200
Message-Id: <20200824082409.868455413@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
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


