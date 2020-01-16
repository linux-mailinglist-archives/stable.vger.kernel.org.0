Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5B813FDD2
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391321AbgAPX3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391316AbgAPX3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A2B1206D9;
        Thu, 16 Jan 2020 23:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217378;
        bh=crauBlMyJ9CkIEHb5/hCZFFpb1CH0hpS+gwPv5Gr3lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4jQC7noFSc2qlUBmkCTGf009d/e9Gc60MBdz+tzARRKNP7UZvqUsatNW+lNtpDnW
         eoXEgRPv55+7YpB0dl6G10OpmRMKB16+QOEpc55M4HqifZTnMn+x3NJ+xFyo4l5rVB
         SzCxNB+ev1k07vNXARJNpR2hf1/5CW9p+2q1VsYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Junwei Zhang <Jerry.Zhang@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.19 32/84] drm/ttm: fix start page for huge page check in ttm_put_pages()
Date:   Fri, 17 Jan 2020 00:18:06 +0100
Message-Id: <20200116231717.499584577@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit ac1e516d5a4c56bf0cb4a3dfc0672f689131cfd4 upstream.

The first page entry is always the same with itself.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Junwei Zhang <Jerry.Zhang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -732,7 +732,7 @@ static void ttm_put_pages(struct page **
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			if (!(flags & TTM_PAGE_FLAG_DMA32) &&
 			    (npages - i) >= HPAGE_PMD_NR) {
-				for (j = 0; j < HPAGE_PMD_NR; ++j)
+				for (j = 1; j < HPAGE_PMD_NR; ++j)
 					if (p++ != pages[i + j])
 					    break;
 
@@ -767,7 +767,7 @@ static void ttm_put_pages(struct page **
 			if (!p)
 				break;
 
-			for (j = 0; j < HPAGE_PMD_NR; ++j)
+			for (j = 1; j < HPAGE_PMD_NR; ++j)
 				if (p++ != pages[i + j])
 				    break;
 


