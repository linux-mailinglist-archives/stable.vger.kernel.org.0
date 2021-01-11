Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935292F1695
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbhAKNyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbhAKNHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83AE12250F;
        Mon, 11 Jan 2021 13:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370431;
        bh=VyYZfqz7pyEM9+NZAw3doltv84BrA+2D3lOrkDVhIgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKwnv/gJqQcPQWULtoPmhnYgUsu3mK1ELcMNhZB+E8q04FCdPYfIq+hnmaSsqJs7s
         D1ksT/mnjywp9FuXAoPersn823P/C98frDGjSQgNKxPtLZ32fMz8+ECKciRUOKee09
         3quU/ok38gXHg78Zlb3LDm5ZY/NczlJVNXsER7ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Dike <jdike@akamai.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 19/77] virtio_net: Fix recursive call to cpus_read_lock()
Date:   Mon, 11 Jan 2021 14:01:28 +0100
Message-Id: <20210111130037.342406655@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -2077,14 +2077,16 @@ static int virtnet_set_channels(struct n
 
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
 


