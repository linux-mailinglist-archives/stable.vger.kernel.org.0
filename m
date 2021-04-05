Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D80353D0E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhDEI6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233400AbhDEI6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CD9C610E8;
        Mon,  5 Apr 2021 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613080;
        bh=1OFJEdSOk9+k2CitKDCY1YZwj0yGmnKRvZ+OURrxXC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdiP0vO+0P4yAgM6+tsUNgJgk0QiJ8zfCu31yrdSQhz1ONDWBuRyHW1nZS4ov8i1+
         OO16qd5V5tgK4g1W9o1WwDlzSg+BAsqAK8yXoJzMb9exu1PbBjegtGAH61NOnS0uUq
         cDkhoUKtdDt7jDiqRKr1XeHKl4MlV6D6Sq6AcuhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/52] vhost: Fix vhost_vq_reset()
Date:   Mon,  5 Apr 2021 10:53:38 +0200
Message-Id: <20210405085022.399134098@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
index 3d7bea15c57b..4b5590f4e98b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -324,8 +324,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->call_ctx = NULL;
 	vq->call = NULL;
 	vq->log_ctx = NULL;
-	vhost_reset_is_le(vq);
 	vhost_disable_cross_endian(vq);
+	vhost_reset_is_le(vq);
 	vq->busyloop_timeout = 0;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
-- 
2.30.1



