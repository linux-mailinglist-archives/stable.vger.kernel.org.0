Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323CC8DA63
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbfHNRNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730828AbfHNRNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:13:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD9EB2063F;
        Wed, 14 Aug 2019 17:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802787;
        bh=P6AgbGaHMiyIDWjZWeRZJ9XZLAL9cDrP6KEQPdIE1RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ha8o+U8wDvXcxfLGq7LjHXRKaAve268Nu6nAphNssYBXHNLI09Fx6eidgrzOXWgVa
         qlp/vYjhZZAVP72JylQy86lqHeqIqWUdedrlbi3bh3d7AK/JTN7lp2gGGQ0AQx0HUm
         8dieO/Du5T00NBsChneyAv4fI3BSyjIG72DpA88Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/69] vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn
Date:   Wed, 14 Aug 2019 19:01:24 +0200
Message-Id: <20190814165747.257519174@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c1ab69268d124ebdbb3864580808188ccd3ea355 ]

So we don't call try to call vfio_unpin_pages() incorrectly.

Fixes: 0a19e61e6d4c ("vfio: ccw: introduce channel program interfaces")
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <33a89467ad6369196ae6edf820cbcb1e2d8d050c.1562854091.git.alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_cp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 1419eaea03d84..5a9e457caef33 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -119,8 +119,10 @@ static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
 				  sizeof(*pa->pa_iova_pfn) +
 				  sizeof(*pa->pa_pfn),
 				  GFP_KERNEL);
-	if (unlikely(!pa->pa_iova_pfn))
+	if (unlikely(!pa->pa_iova_pfn)) {
+		pa->pa_nr = 0;
 		return -ENOMEM;
+	}
 	pa->pa_pfn = pa->pa_iova_pfn + pa->pa_nr;
 
 	ret = pfn_array_pin(pa, mdev);
-- 
2.20.1



