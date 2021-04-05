Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD1353E00
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbhDEJD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237638AbhDEJDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E344A6128A;
        Mon,  5 Apr 2021 09:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613395;
        bh=khVMeroJE9TqWHtGxQZsHpu5jSfqIAr/VTELrdLP8WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2T4nuaYNvsAHVe83cV2F8Q4emLQKcE+DkCCfgmwEtSlOh9IU7b2yKYhugJOSaJ+V
         MmGpJUd1oV6maixJHk7rzyV4fj2XcDfKvDdby2kTlK+czOrCVxmyo3HVYDHn9c+eQm
         eMseh7LNpN/yuCmxXWIGBbJAFkPw4yjALgZOcPVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/74] vhost: Fix vhost_vq_reset()
Date:   Mon,  5 Apr 2021 10:53:45 +0200
Message-Id: <20210405085025.411059749@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
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
index 57ab79fbcee9..a279ecacbf60 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -320,8 +320,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
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



