Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636A916777B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgBUHwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbgBUHwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:52:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5130220801;
        Fri, 21 Feb 2020 07:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271561;
        bh=bxhyd2uGL6csS55UfWR1JBrMopyybW97a+Q4pm8a5Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eii1hgNbbscrI7kf1A9Yr8hqkQlTiXt2XLDKnat8R+vt8oAAza7AQii9427IzqlN0
         NfNiNf2OJbpzYpIhkq0xUQcwezjDJD9oM9+YWKSap4tzdEhOuVI0dusf7G2iXvIGCb
         DZ0raSNFDVm5xhMMYQT8lwwstXz6EpuzuB0BV0Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 213/399] iommu/vt-d: Avoid sending invalid page response
Date:   Fri, 21 Feb 2020 08:38:58 +0100
Message-Id: <20200221072423.704224194@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 5f75585e19cc7018bf2016aa771632081ee2f313 ]

Page responses should only be sent when last page in group (LPIG) or
private data is present in the page request. This patch avoids sending
invalid descriptors.

Fixes: 5d308fc1ecf53 ("iommu/vt-d: Add 256-bit invalidation descriptor support")
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-svm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index ff7a3f9add325..518d0b2d12afd 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -654,11 +654,10 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 			if (req->priv_data_present)
 				memcpy(&resp.qw2, req->priv_data,
 				       sizeof(req->priv_data));
+			resp.qw2 = 0;
+			resp.qw3 = 0;
+			qi_submit_sync(&resp, iommu);
 		}
-		resp.qw2 = 0;
-		resp.qw3 = 0;
-		qi_submit_sync(&resp, iommu);
-
 		head = (head + sizeof(*req)) & PRQ_RING_MASK;
 	}
 
-- 
2.20.1



