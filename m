Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5981A2F15EA
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbhAKNqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731292AbhAKNK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35373225AB;
        Mon, 11 Jan 2021 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370615;
        bh=63roHdYgYBt958WTj+SmDLqMSGhlEAa+0t7ommF5Q/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lqt6q6q/HLiZhkOTeTQhuW4hmHw+QnL90AVaxCkywRqnfGhc25q1I7gX5T/h/IUR0
         2Nn8XsqhDnHJYUa0zoCr3/YC92FTseopsZahlMzRl30WphrnRgAoaCguJ2x2ouHHy5
         mMQnAXIm+izmMkEHgvgh6aZC6Wq8QtBNhMNfWSsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Dike <jdike@akamai.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 22/92] virtio_net: Fix recursive call to cpus_read_lock()
Date:   Mon, 11 Jan 2021 14:01:26 +0100
Message-Id: <20210111130040.220127410@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Dike <jdike@akamai.com>

[ Upstream commit de33212f768c5d9e2fe791b008cb26f92f0aa31c ]

virtnet_set_channels can recursively call cpus_read_lock if CONFIG_XPS
and CONFIG_HOTPLUG are enabled.

The path is:
    virtnet_set_channels - calls get_online_cpus(), which is a trivial
wrapper around cpus_read_lock()
    netif_set_real_num_tx_queues
    netif_reset_xps_queues_gt
    netif_reset_xps_queues - calls cpus_read_lock()

This call chain and potential deadlock happens when the number of TX
queues is reduced.

This commit the removes netif_set_real_num_[tr]x_queues calls from
inside the get/put_online_cpus section, as they don't require that it
be held.

Fixes: 47be24796c13 ("virtio-net: fix the set affinity bug when CPU IDs are not consecutive")
Signed-off-by: Jeff Dike <jdike@akamai.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20201223025421.671-1-jdike@akamai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2072,14 +2072,16 @@ static int virtnet_set_channels(struct n
 
 	get_online_cpus();
 	err = _virtnet_set_queues(vi, queue_pairs);
-	if (!err) {
-		netif_set_real_num_tx_queues(dev, queue_pairs);
-		netif_set_real_num_rx_queues(dev, queue_pairs);
-
-		virtnet_set_affinity(vi);
+	if (err) {
+		put_online_cpus();
+		goto err;
 	}
+	virtnet_set_affinity(vi);
 	put_online_cpus();
 
+	netif_set_real_num_tx_queues(dev, queue_pairs);
+	netif_set_real_num_rx_queues(dev, queue_pairs);
+ err:
 	return err;
 }
 


