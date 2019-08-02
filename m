Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3D27FA7C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393900AbfHBNXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbfHBNXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:23:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D9720880;
        Fri,  2 Aug 2019 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752185;
        bh=lgIcao1FUsYr2I98X1TWGI5JBvZiDsyIgND5NxpgbiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaUPpmLdYBi5ATqml64cPdG5xGqsS8+fYVViScC75/4JPJg5fUzsFNtTmKs6QCREo
         ym2nGcShAVwf51V+ZcYoYst19yLQjF3WKvAhVCOXtDOErr0BIk+LVYifR64K3kVmi3
         ySYsZ3cBGkS/m6074LYgS8qm9q+aLyBEOROVL2rY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/42] vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn
Date:   Fri,  2 Aug 2019 09:22:22 -0400
Message-Id: <20190802132302.13537-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

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
index 70a006ba4d050..4fe06ff7b2c8b 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -89,8 +89,10 @@ static int pfn_array_alloc_pin(struct pfn_array *pa, struct device *mdev,
 				  sizeof(*pa->pa_iova_pfn) +
 				  sizeof(*pa->pa_pfn),
 				  GFP_KERNEL);
-	if (unlikely(!pa->pa_iova_pfn))
+	if (unlikely(!pa->pa_iova_pfn)) {
+		pa->pa_nr = 0;
 		return -ENOMEM;
+	}
 	pa->pa_pfn = pa->pa_iova_pfn + pa->pa_nr;
 
 	pa->pa_iova_pfn[0] = pa->pa_iova >> PAGE_SHIFT;
-- 
2.20.1

