Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC8A28B86E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389586AbgJLNw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731820AbgJLNsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5741E20678;
        Mon, 12 Oct 2020 13:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510429;
        bh=yS/GZOsfdO0c/E3wJYdl36u2gKJujXSMPyRyF1/cqTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzFicFQAXXDNHPzd0clNm2tXJ5bSUbEWPuGdGxjt87717OIwO/PBiVpTA6ha7ld0h
         7SnRMvu8mXwF0DPY9Y2NvdMT2hLwENFPiXebkXdppa6CgnOSVJu2Q9m5xoiu7dU0W+
         fLHbWiHWKaRgDrl3js1dSSkITqaSevLbZrvUYolU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 096/124] vhost-vdpa: fix vhost_vdpa_map() on error condition
Date:   Mon, 12 Oct 2020 15:31:40 +0200
Message-Id: <20201012133151.502584485@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit 1477c8aebb94a1db398c12d929a9d27bbd678d8c ]

vhost_vdpa_map() should remove the iotlb entry just added
if the corresponding mapping fails to set up properly.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Link: https://lore.kernel.org/r/1601701330-16837-2-git-send-email-si-wei.liu@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a54b60d6623f0..5259f5210b375 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -527,6 +527,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 
+	if (r)
+		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
+
 	return r;
 }
 
-- 
2.25.1



