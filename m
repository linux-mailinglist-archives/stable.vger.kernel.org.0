Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6BE13FEC2
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391328AbgAPX3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391323AbgAPX3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54DC2082F;
        Thu, 16 Jan 2020 23:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217381;
        bh=FOFzr0NAm5ktk6Djd9QBwhNzPcrJqu+nWzNrlTcnVL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLp1xBgOVPM4bYhFnPpxafAyMziH3n4HEeCH7jcRGYB1zLyk8750KwV2QjtmUDWej
         2JMVfQXv5prD32t4yVAG9EkAtmU9idtTZ1+9MF1nQzYmfuq+q2o3isbMqg+ETMcDFd
         nJ7MOFsjsychOPjd+LU+DzJllLAn3kFY1Ui0M6bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.19 33/84] drm/ttm: fix incrementing the page pointer for huge pages
Date:   Fri, 17 Jan 2020 00:18:07 +0100
Message-Id: <20200116231717.636874499@linuxfoundation.org>
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

commit 453393369dc9806d2455151e329c599684762428 upstream.

When we increment the counter we need to increment the pointer as well.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: e16858a7e6e7 drm/ttm: fix start page for huge page check in ttm_put_pages()
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -733,7 +733,7 @@ static void ttm_put_pages(struct page **
 			if (!(flags & TTM_PAGE_FLAG_DMA32) &&
 			    (npages - i) >= HPAGE_PMD_NR) {
 				for (j = 1; j < HPAGE_PMD_NR; ++j)
-					if (p++ != pages[i + j])
+					if (++p != pages[i + j])
 					    break;
 
 				if (j == HPAGE_PMD_NR)
@@ -768,7 +768,7 @@ static void ttm_put_pages(struct page **
 				break;
 
 			for (j = 1; j < HPAGE_PMD_NR; ++j)
-				if (p++ != pages[i + j])
+				if (++p != pages[i + j])
 				    break;
 
 			if (j != HPAGE_PMD_NR)


