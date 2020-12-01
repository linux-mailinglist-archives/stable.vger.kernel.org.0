Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C0D2C9D1C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390145AbgLAJTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:19:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389673AbgLAJKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C272222A;
        Tue,  1 Dec 2020 09:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813780;
        bh=2iKQUJsUQI9l2vvcbu3mNWUXjhNPMztzv4VhPexSgrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAr1JeFaC5FPEgoX2POERDEP5YH5EUOlLEUKmQ4Cxt2HOTmMfmBputvJUh5KuaBFQ
         /LpljF0j1N7X6EifM+S3lSCnfVDomWw9eOfufQaH3KObn5Se+Q/uaMZuH6jByoPUF0
         415xy6Mvx6SjB8Rb+jStLUuVplJq5aAYTCbE5mao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 057/152] vhost: add helper to check if a vq has been setup
Date:   Tue,  1 Dec 2020 09:52:52 +0100
Message-Id: <20201201084719.420908068@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 6bcf34224ac1e94103797fd68b9836061762f2b2 ]

This adds a helper check if a vq has been setup. The next patches
will use this when we move the vhost scsi cmd preallocation from per
session to per vq. In the per vq case, we only want to allocate cmds
for vqs that have actually been setup and not for all the possible
vqs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/1604986403-4931-2-git-send-email-michael.christie@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 6 ++++++
 drivers/vhost/vhost.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ad45e1d27f0f..23e7b2d624511 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -305,6 +305,12 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
 	spin_lock_init(&call_ctx->ctx_lock);
 }
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
+{
+	return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
+
 static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9032d3c2a9f48..3d30b3da7bcf5 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -190,6 +190,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
 int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-- 
2.27.0



