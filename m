Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59510B89B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfK0UpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729682AbfK0UpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:45:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23A02166E;
        Wed, 27 Nov 2019 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887502;
        bh=Rd+0N2tiW1RD9LnB2DhtsXFYTisBldFFm7TiN3h3SQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxvWlEKD0iMRv8UV+27/roa4JNK1Z+rVpG8ac3R5QMdFHPIFRtqpAK1CXupDnFZvo
         8WEUh73QHekX6y9V2DHmWWsbfimSLf//7clmDQKh4ixk9W03tzpLEbaMKChdSaFUzk
         flgvfULqx8PeNJlqRTzThzNL7dLb6tR3/cfhXuhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 136/151] virtio_console: fix uninitialized variable use
Date:   Wed, 27 Nov 2019 21:31:59 +0100
Message-Id: <20191127203046.807989445@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 2055997f983c6db7b5c3940ce5f8f822657d5bc3 ]

We try to disable callbacks on c_ivq even without multiport
even though that vq is not initialized in this configuration.

Fixes: c743d09dbd01 ("virtio: console: Disable callbacks for virtqueues at start of S4 freeze")
Suggested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index d7ee031d776d8..7de24040f39c1 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2203,14 +2203,16 @@ static int virtcons_freeze(struct virtio_device *vdev)
 
 	vdev->config->reset(vdev);
 
-	virtqueue_disable_cb(portdev->c_ivq);
+	if (use_multiport(portdev))
+		virtqueue_disable_cb(portdev->c_ivq);
 	cancel_work_sync(&portdev->control_work);
 	cancel_work_sync(&portdev->config_work);
 	/*
 	 * Once more: if control_work_handler() was running, it would
 	 * enable the cb as the last step.
 	 */
-	virtqueue_disable_cb(portdev->c_ivq);
+	if (use_multiport(portdev))
+		virtqueue_disable_cb(portdev->c_ivq);
 	remove_controlq_data(portdev);
 
 	list_for_each_entry(port, &portdev->ports, list) {
-- 
2.20.1



