Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1189C1D0D3C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387647AbgEMJvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732717AbgEMJvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D91D206D6;
        Wed, 13 May 2020 09:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363482;
        bh=90R9d456XOzRYbcfVgnZtYoyVzTMA4FXJCi9jzO42zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c66uPGtOnA2bm3TrgevUyX7TJUoWOwqpG0Mj7aRgu4frzM60B6Jq5tVRnIxhvcxu9
         fk4IXl+6Hr4bDx9qze01wiK0fsxk/Rs55juAwsyXH7xIVNEK5p0wyeIVWyVXiknoIe
         dpEHSaWF9meFtmjGu9XLxF/Hdg++Upd0AQ6FqhQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 84/90] iommu/virtio: Reverse arguments to list_add
Date:   Wed, 13 May 2020 11:45:20 +0200
Message-Id: <20200513094417.937658233@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>

commit fb3637a113349f53830f7d6ca45891b7192cd28f upstream.

Elsewhere in the file, there is a list_for_each_entry with
&vdev->resv_regions as the second argument, suggesting that
&vdev->resv_regions is the list head.  So exchange the
arguments on the list_add call to put the list head in the
second argument.

Fixes: 2a5a31487445 ("iommu/virtio: Add probe request")
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Link: https://lore.kernel.org/r/1588704467-13431-1-git-send-email-Julia.Lawall@inria.fr
Signed-off-by: Joerg Roedel <jroedel@suse.de>

---
 drivers/iommu/virtio-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -454,7 +454,7 @@ static int viommu_add_resv_mem(struct vi
 	if (!region)
 		return -ENOMEM;
 
-	list_add(&vdev->resv_regions, &region->list);
+	list_add(&region->list, &vdev->resv_regions);
 	return 0;
 }
 


