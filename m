Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B091A32C31
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfFCJO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbfFCJOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:14:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4273F27EDC;
        Mon,  3 Jun 2019 09:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553258;
        bh=/jvRGkAHeY0UxBUHI1p2McTbmOlfpHyaJxWBuDG9t14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYUYVUloAJvD0e/ItEHCMxbXwAiPvdyRC+ZcHeYLiZbZ8eufmsuLw5VsDGo62Gw8m
         ulHnc5Jn7QtEf59+HwiXXYiocO0kkc3+lODKr3MI5gHS6hh5hGkGe2LY0isAKR+eog
         hRsSqS1hCo2DgfEX1djBABnpqTqG3IT6pxtlILzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 35/40] net/tls: dont ignore netdev notifications if no TLS features
Date:   Mon,  3 Jun 2019 11:09:28 +0200
Message-Id: <20190603090524.649697567@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit c3f4a6c39cf269a40d45f813c05fa830318ad875 ]

On device surprise removal path (the notifier) we can't
bail just because the features are disabled.  They may
have been enabled during the lifetime of the device.
This bug leads to leaking netdev references and
use-after-frees if there are active connections while
device features are cleared.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1001,7 +1001,8 @@ static int tls_dev_event(struct notifier
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
-	if (!(dev->features & (NETIF_F_HW_TLS_RX | NETIF_F_HW_TLS_TX)))
+	if (!dev->tlsdev_ops &&
+	    !(dev->features & (NETIF_F_HW_TLS_RX | NETIF_F_HW_TLS_TX)))
 		return NOTIFY_DONE;
 
 	switch (event) {


