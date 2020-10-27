Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34FC29BF16
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814948AbgJ0RAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793922AbgJ0PJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:09:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E606420657;
        Tue, 27 Oct 2020 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811346;
        bh=i9pwAcbMBFwVFvTsy6gwZlshudc99nSg7f/5QAsJM/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpBk5a3mN+3a1HHmpJbF9F5zpl2YVS8r5ZbOwm6tmHd3i34+LEd65DW8y0LzpKJQZ
         1s3ZzUtkDf/0uyCjmsyH4bHZDUeKRzEeBDvCWNob9rUuFEB7aopsrBkrb1/2a2hlOx
         XltR63fLsMlhS5j3VA9Dm1AvkSX+JEk2vjwwptyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, guomin chen <guomin_chen@sina.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 461/633] vfio/pci: Clear token on bypass registration failure
Date:   Tue, 27 Oct 2020 14:53:24 +0100
Message-Id: <20201027135544.350637604@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 852b1beecb6ff9326f7ca4bc0fe69ae860ebdb9e ]

The eventfd context is used as our irqbypass token, therefore if an
eventfd is re-used, our token is the same.  The irqbypass code will
return an -EBUSY in this case, but we'll still attempt to unregister
the producer, where if that duplicate token still exists, results in
removing the wrong object.  Clear the token of failed producers so
that they harmlessly fall out when unregistered.

Fixes: 6d7425f109d2 ("vfio: Register/unregister irq_bypass_producer")
Reported-by: guomin chen <guomin_chen@sina.com>
Tested-by: guomin chen <guomin_chen@sina.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1d9fb25929459..869dce5f134dd 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -352,11 +352,13 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	vdev->ctx[vector].producer.token = trigger;
 	vdev->ctx[vector].producer.irq = irq;
 	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
 		"irq bypass producer (token %p) registration fails: %d\n",
 		vdev->ctx[vector].producer.token, ret);
 
+		vdev->ctx[vector].producer.token = NULL;
+	}
 	vdev->ctx[vector].trigger = trigger;
 
 	return 0;
-- 
2.25.1



