Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A782A54B8
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbgKCVNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389303AbgKCVNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28EED207BC;
        Tue,  3 Nov 2020 21:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604438013;
        bh=tycZLcffDK5JXjfxnA7nYvgP1KvzSEqaVcgjCbiEIgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkjS6sHgG3F0m0/UTHv0Lty7iP7UNyyXX9I3u/ZWo5PaZoEE45YsSflKfzStZYzxW
         xEfPRSS6MGPoekLwMpuy15qMw2bqJQfBf0pC5O2bdYFllDawfRyuvCC0JqMZOk3AVy
         ASgcdBUcutLIy7JZQGSiTjpHQM0zL7h/urBkiTIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 4.14 106/125] vringh: fix __vringh_iov() when riov and wiov are different
Date:   Tue,  3 Nov 2020 21:38:03 +0100
Message-Id: <20201103203212.785988018@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 5745bcfbbf89b158416075374254d3c013488f21 upstream.

If riov and wiov are both defined and they point to different
objects, only riov is initialized. If the wiov is not initialized
by the caller, the function fails returning -EINVAL and printing
"Readable desc 0x... after writable" error message.

This issue happens when descriptors have both readable and writable
buffers (eg. virtio-blk devices has virtio_blk_outhdr in the readable
buffer and status as last byte of writable buffer) and we call
__vringh_iov() to get both type of buffers in two different iovecs.

Let's replace the 'else if' clause with 'if' to initialize both
riov and wiov if they are not NULL.

As checkpatch pointed out, we also avoid crashing the kernel
when riov and wiov are both NULL, replacing BUG() with WARN_ON()
and returning -EINVAL.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201008204256.162292-1-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vringh.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -273,13 +273,14 @@ __vringh_iov(struct vringh *vrh, u16 i,
 	desc_max = vrh->vring.num;
 	up_next = -1;
 
+	/* You must want something! */
+	if (WARN_ON(!riov && !wiov))
+		return -EINVAL;
+
 	if (riov)
 		riov->i = riov->used = 0;
-	else if (wiov)
+	if (wiov)
 		wiov->i = wiov->used = 0;
-	else
-		/* You must want something! */
-		BUG();
 
 	for (;;) {
 		void *addr;


