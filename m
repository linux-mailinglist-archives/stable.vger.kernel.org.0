Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54552B6192
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgKQNUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730520AbgKQNUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9FA24695;
        Tue, 17 Nov 2020 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619222;
        bh=QsEl7P4x0/cyE4nicqaewzKyisG21glNGmW7hLq3NPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RExLcXfol9hC0WKj4m2kTIg/8VRwjieaysyIPYiUXxXk69IU3zhg7p29fOLbanoP6
         ruvd7ugZW5gYbqWjKGGvXQQKwEKx03ewp+DMqIBkIDVW9QyMDiO0PDCJ/NL1FdHejn
         qRhhlaROSllIUNe0YrpKxjbDvqeoFGAI5PIv1ks4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.19 068/101] thunderbolt: Add the missed ida_simple_remove() in ring_request_msix()
Date:   Tue, 17 Nov 2020 14:05:35 +0100
Message-Id: <20201117122116.424256053@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

commit 7342ca34d931a357d408aaa25fadd031e46af137 upstream.

ring_request_msix() misses to call ida_simple_remove() in an error path.
Add a label 'err_ida_remove' and jump to it.

Fixes: 046bee1f9ab8 ("thunderbolt: Add MSI-X support")
Cc: stable@vger.kernel.org
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/nhi.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -408,12 +408,23 @@ static int ring_request_msix(struct tb_r
 
 	ring->vector = ret;
 
-	ring->irq = pci_irq_vector(ring->nhi->pdev, ring->vector);
-	if (ring->irq < 0)
-		return ring->irq;
+	ret = pci_irq_vector(ring->nhi->pdev, ring->vector);
+	if (ret < 0)
+		goto err_ida_remove;
+
+	ring->irq = ret;
 
 	irqflags = no_suspend ? IRQF_NO_SUSPEND : 0;
-	return request_irq(ring->irq, ring_msix, irqflags, "thunderbolt", ring);
+	ret = request_irq(ring->irq, ring_msix, irqflags, "thunderbolt", ring);
+	if (ret)
+		goto err_ida_remove;
+
+	return 0;
+
+err_ida_remove:
+	ida_simple_remove(&nhi->msix_ida, ring->vector);
+
+	return ret;
 }
 
 static void ring_release_msix(struct tb_ring *ring)


