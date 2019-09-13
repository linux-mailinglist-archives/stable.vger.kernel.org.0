Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE40B2067
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390842AbfIMNVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390835AbfIMNVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:31 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0204A20717;
        Fri, 13 Sep 2019 13:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380890;
        bh=IK6b26D5Jg6cyt6MmrLyp6L1Bo7XA7kBf8VHbZLBa08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOydHS69szjVBqUg2O4D08DVJ0O94pI24dQ6ldDFzsd7Px7KpymgZ0zygnXSQnIbu
         2xEy5DVna3ISlSmNQv1AjvYW3FMlbfRxYSoGslXvqpi+0m45BMGniYJ+Wj8sIu6Tgu
         WfkCYPPuDUbbYv64NIOgelCf7Tpi3P9C14B1YafY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiwei Bie <tiwei.bie@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.2 11/37] vhost/test: fix build for vhost test
Date:   Fri, 13 Sep 2019 14:07:16 +0100
Message-Id: <20190913130514.076740214@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
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
@@ -115,7 +115,7 @@ static int vhost_test_open(struct inode
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV);
 
 	f->private_data = n;
 


