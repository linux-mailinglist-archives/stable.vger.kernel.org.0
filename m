Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFD438EFDD
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbhEXQAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235783AbhEXP7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB29E6144F;
        Mon, 24 May 2021 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871105;
        bh=WG1NXLp8LD315tqu5BuRcUtXWwveUUwUbSnMh7d7p7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/ggzB4vAOAUy6yoJRs1IQUc/Z4hP/ams8RaITR+7H7DKmiZuMxefCqunRkr/oNTx
         uaRPVRLuMPoRhyLA6kEmhTK+W5MTRXzsfTTlC77lXuLoSrlzJ873hNula3nXiau/fZ
         wHjyKHa4vKm9o9HQYW7m3eGwVlEzDo6ZHOZHsUKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 076/127] drm/radeon: use the dummy page for GART if needed
Date:   Mon, 24 May 2021 17:26:33 +0200
Message-Id: <20210524152337.423141123@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 0c8df343c200529e6b9820bdfed01814140f75e4 upstream.

Imported BOs don't have a pagelist any more.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Fixes: 0575ff3d33cd ("drm/radeon: stop using pages with drm_prime_sg_to_page_addr_arrays v2")
CC: stable@vger.kernel.org # 5.12
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_gart.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -301,7 +301,8 @@ int radeon_gart_bind(struct radeon_devic
 	p = t / (PAGE_SIZE / RADEON_GPU_PAGE_SIZE);
 
 	for (i = 0; i < pages; i++, p++) {
-		rdev->gart.pages[p] = pagelist[i];
+		rdev->gart.pages[p] = pagelist ? pagelist[i] :
+			rdev->dummy_page.page;
 		page_base = dma_addr[i];
 		for (j = 0; j < (PAGE_SIZE / RADEON_GPU_PAGE_SIZE); j++, t++) {
 			page_entry = radeon_gart_get_page_entry(page_base, flags);


