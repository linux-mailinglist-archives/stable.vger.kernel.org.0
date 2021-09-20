Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE8D412525
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352886AbhITSll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344665AbhITShD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A95CE63321;
        Mon, 20 Sep 2021 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158981;
        bh=+aOKN79u/yNR5M+m0bDC0Hpr5E/kF8ffft15uvOO8pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0LdR0eruamefS5iVAn1BWj4LKuEAizFi5Bq9MCGvt7Zeb6zqsayU84FUsfNFOHoA
         2HIDT09kEuFF0qCRKWJMjNBzaeIEEktoJw5z8jeVj66HjrbrMid7B1jlOCcfyr2GVH
         nOai+n2vZPW+WuBBW4Ow+hqkKZgraHh14Mfu+qSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 021/168] drm/radeon: pass drm dev radeon_agp_head_init directly
Date:   Mon, 20 Sep 2021 18:42:39 +0200
Message-Id: <20210920163922.343943832@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

commit 93def70cf8b23de5049d101b7dd5367864694bd3 upstream.

Pass drm dev directly as rdev->ddev gets initialized later on
at radeon_device_init().

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=214375
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -119,7 +119,7 @@ int radeon_driver_load_kms(struct drm_de
 #endif
 
 	if (pci_find_capability(pdev, PCI_CAP_ID_AGP))
-		rdev->agp = radeon_agp_head_init(rdev->ddev);
+		rdev->agp = radeon_agp_head_init(dev);
 	if (rdev->agp) {
 		rdev->agp->agp_mtrr = arch_phys_wc_add(
 			rdev->agp->agp_info.aper_base,


