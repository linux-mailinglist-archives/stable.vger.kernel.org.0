Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1A61C4465
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgEDSG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbgEDSG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:06:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 828432073B;
        Mon,  4 May 2020 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615615;
        bh=qmok/smR5p8JzoYGwRx25aI23XUjwrs5b7JAFG9KgD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgUn72JvZF8kGEIuJzduApoZLjSH4MXsRcx5BmzC93dQr9+jELMf0wPN7HqdK3Ewm
         YHCf99DUxsdx28Yd3f4fp6uFFNaH4cEL91IZy1K18IEhE2GBXNX+Jn9lVKCZsw40b7
         /YlC6dI8JLOyV6/BowqpCGTN273VkD+PZTaZnAMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.6 54/73] vfio: avoid possible overflow in vfio_iommu_type1_pin_pages
Date:   Mon,  4 May 2020 19:57:57 +0200
Message-Id: <20200504165509.404568015@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

commit 0ea971f8dcd6dee78a9a30ea70227cf305f11ff7 upstream.

add parentheses to avoid possible vaddr overflow.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/vfio_iommu_type1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -554,7 +554,7 @@ static int vfio_iommu_type1_pin_pages(vo
 			continue;
 		}
 
-		remote_vaddr = dma->vaddr + iova - dma->iova;
+		remote_vaddr = dma->vaddr + (iova - dma->iova);
 		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
 					     do_accounting);
 		if (ret)


