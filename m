Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF70B1FF1
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389039AbfIMNLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389035AbfIMNLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:50 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7854E214D8;
        Fri, 13 Sep 2019 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380310;
        bh=VqNzzUOuKwTukUd28y7P1lYA35/hn2Tp0oQEZy8nl/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9OHFR0Xca514RMA1A4PoWaZu6jIeV+Fsoi1X5Tl5iet0y4Ks9VxIN9ruQvprFjo3
         J2rmPFeW3hkM51ieNjMFP8blRiB19txiqSlveoRA+a1QZj52F2m4tocDBP+ABySAIv
         /IfipXXRh5FgtzFPxiWzIzh/1biPUq4AMZJoo4G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiwei Bie <tiwei.bie@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 4.19 008/190] vhost/test: fix build for vhost test
Date:   Fri, 13 Sep 2019 14:04:23 +0100
Message-Id: <20190913130600.303904103@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiwei Bie <tiwei.bie@intel.com>

commit 93d2c4de8d8129b97ee1e1a222aedb0719d2fcd9 upstream.

Since below commit, callers need to specify the iov_limit in
vhost_dev_init() explicitly.

Fixes: b46a0bf78ad7 ("vhost: fix OOB in get_rx_bufs()")
Cc: stable@vger.kernel.org
Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -116,7 +116,7 @@ static int vhost_test_open(struct inode
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV);
 
 	f->private_data = n;
 


