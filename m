Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64666531798
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbiEWRdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241402AbiEWRaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA793EA80;
        Mon, 23 May 2022 10:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54C66B81205;
        Mon, 23 May 2022 17:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFC5C385AA;
        Mon, 23 May 2022 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326768;
        bh=3pj742xwTH//GhvySybOz166D7IPXF4+QSlKRBP5RUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLa08KKJWifYScCx/2eaAWAY6Jj4xdyGsHyV8fkMdGpKs3Brs+n7b7HFaCuKnyehp
         fujX9ME2ljX6nm8nRCH+DoH9TmzwJql5/3uWxgICsDAvTRYkf52JS1mcu/BgKryn9H
         rB1TmA4lqy1FM1Q5pG2VN+mY21YmAz1z0YMgz3hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.17 052/158] Fix double fget() in vhost_net_set_backend()
Date:   Mon, 23 May 2022 19:03:29 +0200
Message-Id: <20220523165839.356960594@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit fb4554c2232e44d595920f4d5c66cf8f7d13f9bc upstream.

Descriptor table is a shared resource; two fget() on the same descriptor
may return different struct file references.  get_tap_ptr_ring() is
called after we'd found (and pinned) the socket we'll be using and it
tries to find the private tun/tap data structures associated with it.
Redoing the lookup by the same file descriptor we'd used to get the
socket is racy - we need to same struct file.

Thanks to Jason for spotting a braino in the original variant of patch -
I'd missed the use of fd == -1 for disabling backend, and in that case
we can end up with sock == NULL and sock != oldsock.

Cc: stable@kernel.org
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1450,13 +1450,9 @@ err:
 	return ERR_PTR(r);
 }
 
-static struct ptr_ring *get_tap_ptr_ring(int fd)
+static struct ptr_ring *get_tap_ptr_ring(struct file *file)
 {
 	struct ptr_ring *ring;
-	struct file *file = fget(fd);
-
-	if (!file)
-		return NULL;
 	ring = tun_get_tx_ring(file);
 	if (!IS_ERR(ring))
 		goto out;
@@ -1465,7 +1461,6 @@ static struct ptr_ring *get_tap_ptr_ring
 		goto out;
 	ring = NULL;
 out:
-	fput(file);
 	return ring;
 }
 
@@ -1552,8 +1547,12 @@ static long vhost_net_set_backend(struct
 		r = vhost_net_enable_vq(n, vq);
 		if (r)
 			goto err_used;
-		if (index == VHOST_NET_VQ_RX)
-			nvq->rx_ring = get_tap_ptr_ring(fd);
+		if (index == VHOST_NET_VQ_RX) {
+			if (sock)
+				nvq->rx_ring = get_tap_ptr_ring(sock->file);
+			else
+				nvq->rx_ring = NULL;
+		}
 
 		oldubufs = nvq->ubufs;
 		nvq->ubufs = ubufs;


