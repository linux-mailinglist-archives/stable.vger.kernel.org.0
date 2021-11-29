Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3345460F40
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbhK2HWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbhK2HUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 02:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A44C061756
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 23:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D15B611DD
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 07:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA42C004E1;
        Mon, 29 Nov 2021 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638170186;
        bh=Ji7lGI+sNiSRS/Y6MYjOZj5MqwzRYIwEU9VEN4XrqHM=;
        h=Subject:To:Cc:From:Date:From;
        b=naEfpAEWEsAGfa2QWaPMeo+klZU1ghOmWucqKb9qv0QkgxK0wy53uCP4kK+sQoWK3
         l/QQV5BRCS49AKpr/mscrMeLjEQqQlSnYwbxRaU36DqPf0eSpZsBXnU5XCOkIRpPY1
         GIIai6DkClC0eG0V2zVqPIAv58BMpPj/BkQrqCrc=
Subject: FAILED: patch "[PATCH] vhost/vsock: fix incorrect used length reported to the guest" failed to apply to 4.9-stable tree
To:     sgarzare@redhat.com, jasowang@redhat.com, mst@redhat.com,
        pasic@linux.ibm.com, stefanha@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 08:16:23 +0100
Message-ID: <163817018318163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 49d8c5ffad07ca014cfae72a1b9b8c52b6ad9cb8 Mon Sep 17 00:00:00 2001
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Mon, 22 Nov 2021 17:35:24 +0100
Subject: [PATCH] vhost/vsock: fix incorrect used length reported to the guest

The "used length" reported by calling vhost_add_used() must be the
number of bytes written by the device (using "in" buffers).

In vhost_vsock_handle_tx_kick() the device only reads the guest
buffers (they are all "out" buffers), without writing anything,
so we must pass 0 as "used length" to comply virtio spec.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Cc: stable@vger.kernel.org
Reported-by: Halil Pasic <pasic@linux.ibm.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20211122163525.294024-2-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 938aefbc75ec..4e3b95af7ee4 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -554,7 +554,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			virtio_transport_free_pkt(pkt);
 
 		len += sizeof(pkt->hdr);
-		vhost_add_used(vq, head, len);
+		vhost_add_used(vq, head, 0);
 		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));

