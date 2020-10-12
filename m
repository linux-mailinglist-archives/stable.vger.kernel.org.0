Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE47E28B74D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389248AbgJLNm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387650AbgJLNlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6CF72074F;
        Mon, 12 Oct 2020 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510099;
        bh=ouw9VRswycVQhXzt4kEBILuUJIeErob8/b6m9c88zvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYHnDuo5M6JDXQtzBaVeSzvz15ZkxMf1ykkrN5UjiYrw07XICyXv38fBWXcyZs/Lg
         sFmfXSuc/miuAoOgtupCz5K/el9r1ZJ1cRZVXJ1yp+BNRqe1E/D/v9UXQO0G/iYC7n
         r5OEPjPYOS3eJu0EmWQfcCkFQqx17buzdyiRJNv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.4 12/85] vhost: Use vhost_get_used_size() in vhost_vring_set_addr()
Date:   Mon, 12 Oct 2020 15:26:35 +0200
Message-Id: <20201012132633.455022343@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit 71878fa46c7e3b40fa7b3f1b6e4ba3f92f1ac359 upstream.

The open-coded computation of the used size doesn't take the event
into account when the VIRTIO_RING_F_EVENT_IDX feature is present.
Fix that by using vhost_get_used_size().

Fixes: 8ea8cf89e19a ("vhost: support event index")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kurz <groug@kaod.org>
Link: https://lore.kernel.org/r/160171932300.284610.11846106312938909461.stgit@bahia.lan
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vhost.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1545,8 +1545,7 @@ static long vhost_vring_set_addr(struct
 		/* Also validate log access for used ring if enabled. */
 		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
 			!log_access_ok(vq->log_base, a.log_guest_addr,
-				sizeof *vq->used +
-				vq->num * sizeof *vq->used->ring))
+				       vhost_get_used_size(vq, vq->num)))
 			return -EINVAL;
 	}
 


