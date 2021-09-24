Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE274172BB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344214AbhIXMvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344349AbhIXMtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:49:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E4F66124B;
        Fri, 24 Sep 2021 12:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487672;
        bh=tp9Rs2YYa8tGFsE1HQguKml2q//FxLuvQGATZiMcmYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRMJpqdW9SXx7BRWWp7OPaMfq63zeeuCe4iwtbvitFVZOurxXBaj/Utd3koZGUPEC
         A1xo4wztYytIVrSDPfyiUbkCBQqO/AB0vpr7/amFGgXwmPtzrHvjBdfB9BHp8S4ZOx
         +vTroO4i4kdIxMZErSdVedRehvBys3Hc/KfrZS3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.14 09/27] 9p/trans_virtio: Remove sysfs file on probe failure
Date:   Fri, 24 Sep 2021 14:44:03 +0200
Message-Id: <20210924124329.487898660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
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
@@ -602,7 +602,7 @@ static int p9_virtio_probe(struct virtio
 	chan->vc_wq = kmalloc(sizeof(wait_queue_head_t), GFP_KERNEL);
 	if (!chan->vc_wq) {
 		err = -ENOMEM;
-		goto out_free_tag;
+		goto out_remove_file;
 	}
 	init_waitqueue_head(chan->vc_wq);
 	chan->ring_bufs_avail = 1;
@@ -620,6 +620,8 @@ static int p9_virtio_probe(struct virtio
 
 	return 0;
 
+out_remove_file:
+	sysfs_remove_file(&vdev->dev.kobj, &dev_attr_mount_tag.attr);
 out_free_tag:
 	kfree(tag);
 out_free_vq:


