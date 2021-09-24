Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296CD4172D1
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344503AbhIXMvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344019AbhIXMuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2194161263;
        Fri, 24 Sep 2021 12:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487693;
        bh=ouAl9kHT6zBoIB9XgltFj93veoII8CkLD8fdgp3Ux2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVujgrmduN5KqDaf8ys1FSQtWfjlzr+JRTPoxx9z6gUfesVJMAEdAXvJ4S9eE249F
         frQhQuRqkqZKWlPsUqUcLIkCmVjkqFDOF1moX6XQIo3fRmp0xCrgBNZyr1gbvwiLtB
         1SC4kqZXMvo07vh+sbwCajy5IABjg1uieS0aA9kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.19 11/34] 9p/trans_virtio: Remove sysfs file on probe failure
Date:   Fri, 24 Sep 2021 14:44:05 +0200
Message-Id: <20210924124330.333180805@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

commit f997ea3b7afc108eb9761f321b57de2d089c7c48 upstream.

This ensures we don't leak the sysfs file if we failed to
allocate chan->vc_wq during probe.

Link: http://lkml.kernel.org/r/20210517083557.172-1-xieyongji@bytedance.com
Fixes: 86c8437383ac ("net/9p: Add sysfs mount_tag file for virtio 9P device")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_virtio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -620,7 +620,7 @@ static int p9_virtio_probe(struct virtio
 	chan->vc_wq = kmalloc(sizeof(wait_queue_head_t), GFP_KERNEL);
 	if (!chan->vc_wq) {
 		err = -ENOMEM;
-		goto out_free_tag;
+		goto out_remove_file;
 	}
 	init_waitqueue_head(chan->vc_wq);
 	chan->ring_bufs_avail = 1;
@@ -638,6 +638,8 @@ static int p9_virtio_probe(struct virtio
 
 	return 0;
 
+out_remove_file:
+	sysfs_remove_file(&vdev->dev.kobj, &dev_attr_mount_tag.attr);
 out_free_tag:
 	kfree(tag);
 out_free_vq:


