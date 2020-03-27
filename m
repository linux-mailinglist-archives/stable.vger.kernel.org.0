Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7E6195AFC
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 17:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgC0QXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 12:23:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60815 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgC0QXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 12:23:33 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200327162331euoutp02c6171511862568fd2befb7d505a5bdf7~ANcpFEckm1170011700euoutp02d
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 16:23:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200327162331euoutp02c6171511862568fd2befb7d505a5bdf7~ANcpFEckm1170011700euoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585326211;
        bh=FNcGHf3TErelyQyr0Jn7U9qXzR3Cb8ZHEa9kuu5TYeA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qlHuu19zdZeIrsu0DMoKtCl0dHgdmwwydb48UMvM0E89/FHlQVLAuFaI3ocz+MH2w
         huiwP0UImKHgwcTuwZgoHZVTbnx2AfGdWhzams0LXzvKh91WZBjzTk3Bq32BnhLCfu
         C/JwW3JWgUH0JO/GoEMhgmDfIC32SnKCPOJ624v4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200327162330eucas1p248c9d4d771ddacebcd39c77c7d91e700~ANcoFYz_K3181231812eucas1p28;
        Fri, 27 Mar 2020 16:23:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id CD.5D.60679.2882E7E5; Fri, 27
        Mar 2020 16:23:30 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd~ANcnkxzW12015620156eucas1p1X;
        Fri, 27 Mar 2020 16:23:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200327162330eusmtrp1e3c051d09a2f3de797a2bf04d0500afc~ANcnj_tgS2160721607eusmtrp1_;
        Fri, 27 Mar 2020 16:23:30 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-b5-5e7e2882d3d4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 86.9A.08375.1882E7E5; Fri, 27
        Mar 2020 16:23:29 +0000 (GMT)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200327162329eusmtip29f9109aa332277093a721501edfa2888~ANcm1vZUK2356123561eusmtip27;
        Fri, 27 Mar 2020 16:23:29 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Shane Francis <bigbeeshane@gmail.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>
Subject: [PATCH v2] drm/prime: fix extracting of the DMA addresses from a
 scatterlist
Date:   Fri, 27 Mar 2020 17:21:26 +0100
Message-Id: <20200327162126.29705-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSa0hTURzn3Neu5ux6FTpUGM7sbWZFnOhpFNwkwj5JgsulNw2dxpaWZuVm
        SWqJ2kNZIZtmvjJzrpkzrS1rDElLrSx6TXpZSc10pGS1eVd9+z35/Q8cGmcbydn0/tSDvCJV
        liKhvAnj/YneUPWiY9IVFlUQOtNjw9CFF+0kai5vIpGqrQhDv40lOBoY/0qhftMlCpX3dmKo
        seulCOkcNwj0sHUJysu/QiJt8xBAhi8l5GZf7mTfFMV1OLUE16Z5KeKqbg1jnL4+n+JanW9I
        rsK2i3tdaMW4IkM94Fq6j3Df9YFRM2K81yfwKfszeEXYxjjvpIomO3bgpv/h9nMfyRxgmlkA
        vGjIrIbvy2rIAuBNs0wtgG+6TB4yBqDurtpDvgPY26/G/lZM5l+UYNQA+GDKif2rDJZ8AO4U
        xYTDgpECV0pEBzD7YDXujuBMLw5fvTWL3BF/JhoWT6gpNyaYEFioqyXcWMxsgJUVpZ6xebDh
        +p3pMmT0InhX5RQJxlao/zEABOwPP1kNHn0u7D57mhAKuQDaexpFAjkNYL+63NNYB1/0TLqm
        addNi2GTKUyQI2DzI8e0DBlfODji55ZxFyw1luGCLIan8lghvQBqrNf+zZof9uEC5qCuI3/6
        XSwTCx8bCvFiEKj5v6UFoB7M4tOV8kReuTKVP7RcKZMr01MTl8enyfXA9Ym6f1nHbgLTz70W
        wNBA4iOufXxUypKyDGWm3AIgjUsCxO92Z0tZcYIsM4tXpO1RpKfwSguYQxOSWeJVlcOxLJMo
        O8gn8/wBXvHXxWiv2TkAtmi2VGWs9dEu++wrX9q6+rZ8vE76pCbi25rjk0EDtlA02u+4eC96
        047yXMqhCXk6yZ2wRmwLrMxvqo7sgmHPk6PyTgR3DhntuXxyZK3K+XvUnOGXVh1blxlraxjM
        YofPy19bbCuvDmcn7bQ/i5cOxc2/vD0mqCO4Z6ERZeUgCaFMkoUvwRVK2R8afjKsQAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e/4Pd1Gjbo4g/lPrC16z51ksph2Zzer
        xcYZ61ktGnf2MVn83zaR2eLK1/dsFpd3zWGzmHF+H5PF2iN32S0WftzKYnFhu5ZFW+cyVosF
        Gx8xWmx5M5HVgc+j9dJfNo+93xaweOycdZfdY/Gel0wem1Z1snls//aA1WPeyUCP+93HmTz6
        tqxi9Nh8utrj8ya5AO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU
        1JzMstQifbsEvYx56x8yFewQrtg95QVrA+Mu/i5GTg4JAROJXQf/sXUxcnEICSxllNh6cxcj
        REJG4uS0BlYIW1jiz7UuqKJPjBLtP9aBJdgEDCW63oIkODlEBDIk2idOZQaxmQWuM0sc/1cG
        YgsLhEpM/TUJbCiLgKpE98IVLCA2r4CtxKJ5k5ggFshLrN5wgHkCI88CRoZVjCKppcW56bnF
        hnrFibnFpXnpesn5uZsYgRGw7djPzTsYL20MPsQowMGoxMO74mptnBBrYllxZe4hRgkOZiUR
        3qeRNXFCvCmJlVWpRfnxRaU5qcWHGE2Blk9klhJNzgdGZ15JvKGpobmFpaG5sbmxmYWSOG+H
        wMEYIYH0xJLU7NTUgtQimD4mDk6pBkb+3PQfrksrrqzf5hCTwP/pyMfC+zOljruGC3Jv2pNg
        xC0an70g8eU0Q986+ejcCXE663ecUu6x/+liuTGxd698Xa4Ux/z1zMf8RRX2qLE2//0v3aSV
        WF/0ecXxdeanpZfrz1js9lVC2K/G6sneWU7bn/490LIhbaHJ9ZOPWzMUsvaaTTX//1mJpTgj
        0VCLuag4EQCez0qLlgIAAA==
X-CMS-MailID: 20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd
References: <CGME20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd@eucas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Scatterlist elements contains both pages and DMA addresses, but one
should not assume 1:1 relation between them. The sg->length is the size
of the physical memory chunk described by the sg->page, while
sg_dma_len(sg) is the size of the DMA (IO virtual) chunk described by
the sg_dma_address(sg).

The proper way of extracting both: pages and DMA addresses of the whole
buffer described by a scatterlist it to iterate independently over the
sg->pages/sg->length and sg_dma_address(sg)/sg_dma_len(sg) entries.

Fixes: 42e67b479eab ("drm/prime: use dma length macro when mapping sg")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/gpu/drm/drm_prime.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 1de2cde2277c..282774e469ac 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -962,27 +962,40 @@ int drm_prime_sg_to_page_addr_arrays(struct sg_table *sgt, struct page **pages,
 	unsigned count;
 	struct scatterlist *sg;
 	struct page *page;
-	u32 len, index;
+	u32 page_len, page_index;
 	dma_addr_t addr;
+	u32 dma_len, dma_index;
 
-	index = 0;
+	/*
+	 * Scatterlist elements contains both pages and DMA addresses, but
+	 * one shoud not assume 1:1 relation between them. The sg->length is
+	 * the size of the physical memory chunk described by the sg->page,
+	 * while sg_dma_len(sg) is the size of the DMA (IO virtual) chunk
+	 * described by the sg_dma_address(sg).
+	 */
+	page_index = 0;
+	dma_index = 0;
 	for_each_sg(sgt->sgl, sg, sgt->nents, count) {
-		len = sg_dma_len(sg);
+		page_len = sg->length;
 		page = sg_page(sg);
+		dma_len = sg_dma_len(sg);
 		addr = sg_dma_address(sg);
 
-		while (len > 0) {
-			if (WARN_ON(index >= max_entries))
+		while (pages && page_len > 0) {
+			if (WARN_ON(page_index >= max_entries))
 				return -1;
-			if (pages)
-				pages[index] = page;
-			if (addrs)
-				addrs[index] = addr;
-
+			pages[page_index] = page;
 			page++;
+			page_len -= PAGE_SIZE;
+			page_index++;
+		}
+		while (addrs && dma_len > 0) {
+			if (WARN_ON(dma_index >= max_entries))
+				return -1;
+			addrs[dma_index] = addr;
 			addr += PAGE_SIZE;
-			len -= PAGE_SIZE;
-			index++;
+			dma_len -= PAGE_SIZE;
+			dma_index++;
 		}
 	}
 	return 0;
-- 
2.17.1

