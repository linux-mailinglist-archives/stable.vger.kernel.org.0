Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8ECC157712
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgBJM5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729337AbgBJMla (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:30 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 048D9208C4;
        Mon, 10 Feb 2020 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338490;
        bh=SbCIt7burNVjQ+p/Wtx/l3fzjQLeNUpp9lMGlGWjqvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGYbbZDPHeK9EaLj0SSCwmPP1XXql5vwXZtFgZ+uvAYPjpim+M1QGp+Eq/F986V0W
         0In8Nel6OSFASqvK5SMCm9oOn62iWsyxNm8+hOxnMWgM0FszdpatbLaF6YRG0g2HuC
         VmztzHNWocm3wkTJkg4ZWpAvTGdZO84VgE3HrBA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Daniel Verkamp <dverkamp@chromium.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.5 274/367] virtio-balloon: initialize all vq callbacks
Date:   Mon, 10 Feb 2020 04:33:07 -0800
Message-Id: <20200210122449.510494704@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Verkamp <dverkamp@chromium.org>

commit 5790b53390e18fdd21e70776e46d058c05eda2f2 upstream.

Ensure that elements of the callbacks array that correspond to
unavailable features are set to NULL; previously, they would be left
uninitialized.

Since the corresponding names array elements were explicitly set to
NULL, the uninitialized callback pointers would not actually be
dereferenced; however, the uninitialized callbacks elements would still
be read in vp_find_vqs_msix() and used to calculate the number of MSI-X
vectors required.

Cc: stable@vger.kernel.org
Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_balloon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -475,7 +475,9 @@ static int init_vqs(struct virtio_balloo
 	names[VIRTIO_BALLOON_VQ_INFLATE] = "inflate";
 	callbacks[VIRTIO_BALLOON_VQ_DEFLATE] = balloon_ack;
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
+	callbacks[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
+	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {


