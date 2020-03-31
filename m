Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B971991F5
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgCaJGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730763AbgCaJGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:06:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0655B20675;
        Tue, 31 Mar 2020 09:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645609;
        bh=OAysM2RXWC2WsCwakJq2FQM7u+XDvtE4gRUhwGYw+yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zd17KOK+B569+OgM59Ir+7HO8lyXMy6ZUCXx7tZ+knpxy6nYd7BXiProEePfUffmd
         wwyAmxhl6+63qDk6TnTaNSHwBYHv9zG7kjVMBxFeyHzSRa5jnaUDZ1aYRLr1iK/LmL
         85cDL/F5R31Y3owiAulbpQd5SdYzOCQ4e0GUnXyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shane Francis <bigbeeshane@gmail.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 105/170] drm/radeon: fix scatter-gather mapping with user pages
Date:   Tue, 31 Mar 2020 10:58:39 +0200
Message-Id: <20200331085435.340112787@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shane Francis <bigbeeshane@gmail.com>

commit 47f7826c520ecd92ffbffe59ecaa2fe61e42ec70 upstream.

Calls to dma_map_sg may return less segments / entries than requested
if they fall on page bounderies. The old implementation did not
support this use case.

Fixes: be62dbf554c5 ("iommu/amd: Convert AMD iommu driver to the dma-iommu api")
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206461
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206895
Bug: https://gitlab.freedesktop.org/drm/amd/issues/1056
Signed-off-by: Shane Francis <bigbeeshane@gmail.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200325090741.21957-4-bigbeeshane@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -528,7 +528,7 @@ static int radeon_ttm_tt_pin_userptr(str
 
 	r = -ENOMEM;
 	nents = dma_map_sg(rdev->dev, ttm->sg->sgl, ttm->sg->nents, direction);
-	if (nents != ttm->sg->nents)
+	if (nents == 0)
 		goto release_sg;
 
 	drm_prime_sg_to_page_addr_arrays(ttm->sg, ttm->pages,


