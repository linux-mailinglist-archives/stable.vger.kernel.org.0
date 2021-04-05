Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A93353D8E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhDEJAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237153AbhDEJAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C632610E8;
        Mon,  5 Apr 2021 09:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613224;
        bh=uBIhWWjaumqUkT48h+0CFrN6UT3+lsecp0oxcgqB+l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/zV3grINDFUtWSgmsCZXxo7ccVQo1gg83LL6fybmlwvjSvCGTnF+Tcv+ESNj1xnQ
         2FsKNZY3dRKDTUfxMdR5jOkdt7NFK5FNyfnaYnOOW3qy5t2LB/ao8QmJXd0HUHc9vC
         A9g7ij1IYgqdw/0c/4EZippsYVzoykigjd28UA6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/56] vhost: Fix vhost_vq_reset()
Date:   Mon,  5 Apr 2021 10:53:45 +0200
Message-Id: <20210405085023.003725355@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit beb691e69f4dec7bfe8b81b509848acfd1f0dbf9 ]

vhost_reset_is_le() is vhost_init_is_le(), and in the case of
cross-endian legacy, vhost_init_is_le() depends on vq->user_be.

vq->user_be is set by vhost_disable_cross_endian().

But in vhost_vq_reset(), we have:

    vhost_reset_is_le(vq);
    vhost_disable_cross_endian(vq);

And so user_be is used before being set.

To fix that, reverse the lines order as there is no other dependency
between them.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20210312140913.788592-1-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 98b6eb902df9..732327756ee1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -322,8 +322,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->kick = NULL;
 	vq->call_ctx = NULL;
 	vq->log_ctx = NULL;
-	vhost_reset_is_le(vq);
 	vhost_disable_cross_endian(vq);
+	vhost_reset_is_le(vq);
 	vq->busyloop_timeout = 0;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
-- 
2.30.1



