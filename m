Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D2F198FD6
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgCaJGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730763AbgCaJGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:06:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF35E20675;
        Tue, 31 Mar 2020 09:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645605;
        bh=q1Wq3oXTi7QJHrqZ3v5qjUsU0inZfTf2XVcsAVXiihY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0rj/Zv07Cdhs0yV1srYikjaM+w+C6q4Cb3z4Bk98qzuf8HFtJat42oxUDtJZ2niD
         8S3BKvpBl92SQjbF14q9pGpE7PlXcCkKpSMyqC4dlK6IumFiPTLgkUakAizWPm+NjI
         P8QAETYEdKut9MYq7lvkK6p4xGanwzCNyTdN9Agc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shane Francis <bigbeeshane@gmail.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 104/170] drm/amdgpu: fix scatter-gather mapping with user pages
Date:   Tue, 31 Mar 2020 10:58:38 +0200
Message-Id: <20200331085435.243545182@linuxfoundation.org>
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

commit 0199172f933342d8b1011aae2054a695c25726f4 upstream.

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
Link: https://patchwork.freedesktop.org/patch/msgid/20200325090741.21957-3-bigbeeshane@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -973,7 +973,7 @@ static int amdgpu_ttm_tt_pin_userptr(str
 	/* Map SG to device */
 	r = -ENOMEM;
 	nents = dma_map_sg(adev->dev, ttm->sg->sgl, ttm->sg->nents, direction);
-	if (nents != ttm->sg->nents)
+	if (nents == 0)
 		goto release_sg;
 
 	/* convert SG to linear array of pages and dma addresses */


