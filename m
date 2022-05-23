Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F022E531BFE
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242309AbiEWRkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244197AbiEWRi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1EA9A997;
        Mon, 23 May 2022 10:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94552B81221;
        Mon, 23 May 2022 17:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E478FC385A9;
        Mon, 23 May 2022 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326095;
        bh=LD/W7uHd1vOMPsmRa4IOtCa8tUX9XnTD7hg00Yjc+7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agjidTwoxWpU5JzjKflnlDv3QvpPvXQjkWUPZ2NZUZ6gpVJ0KxuWCAVPoVarKa7ay
         4VlWhlUGeJOSeJ+2H+8x3gTbcusU6cBsrrpCpWkJcXab+RtETAtI7R4v/ZTN/Wcym6
         ciJ0MpUc6A22YeJTQupCp+xKW9lG5q5JiYI2dGMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.4 28/68] Fix double fget() in vhost_net_set_backend()
Date:   Mon, 23 May 2022 19:04:55 +0200
Message-Id: <20220523165807.276439249@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
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
@@ -1446,13 +1446,9 @@ err:
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
@@ -1461,7 +1457,6 @@ static struct ptr_ring *get_tap_ptr_ring
 		goto out;
 	ring = NULL;
 out:
-	fput(file);
 	return ring;
 }
 
@@ -1548,8 +1543,12 @@ static long vhost_net_set_backend(struct
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


