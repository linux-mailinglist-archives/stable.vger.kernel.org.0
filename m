Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA515764D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgBJMuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730137AbgBJMoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:44:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77E202080C;
        Mon, 10 Feb 2020 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338644;
        bh=PuO13LKVTYDSxri5SOudHC2t0XeLAaovGg0Nb14h168=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGeMSIs1F8jF9VYoxo/WvVBh17QJyM5CoKJJkQjyqC5n+MsfdelcLBp/Q96hX2nyx
         T5OG741rfow1WrkrQ89G1mrE8ZksYsAKnTq0wPdyrGhXiTyeq24bNo08kDHjyXSEMb
         hevvPcD711pemuhYU2IP25wA8s6C6pG0MpnKWdZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Daniel Verkamp <dverkamp@chromium.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>
Subject: [PATCH 5.5 275/367] virtio-pci: check name when counting MSI-X vectors
Date:   Mon, 10 Feb 2020 04:33:08 -0800
Message-Id: <20200210122449.575683757@linuxfoundation.org>
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

commit 303090b513fd1ee45aa1536b71a3838dc054bc05 upstream.

VQs without a name specified are not valid; they are skipped in the
later loop that assigns MSI-X vectors to queues, but the per_vq_vectors
loop above that counts the required number of vectors previously still
counted any queue with a non-NULL callback as needing a vector.

Add a check to the per_vq_vectors loop so that vectors with no name are
not counted to make the two loops consistent.  This prevents
over-counting unnecessary vectors (e.g. for features which were not
negotiated with the device).

Cc: stable@vger.kernel.org
Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Wang, Wei W <wei.w.wang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_pci_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -294,7 +294,7 @@ static int vp_find_vqs_msix(struct virti
 		/* Best option: one for change interrupt, one per vq. */
 		nvectors = 1;
 		for (i = 0; i < nvqs; ++i)
-			if (callbacks[i])
+			if (names[i] && callbacks[i])
 				++nvectors;
 	} else {
 		/* Second best: one for change, shared for all vqs. */


