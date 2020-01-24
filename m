Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B0E147BD4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbgAXJqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731991AbgAXJqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:46:32 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1FC6208C4;
        Fri, 24 Jan 2020 09:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859192;
        bh=+6ITeo2PDIUhzNARjYzusiMuQUvcbHpmFeNWausG/Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jyg15YxN81jeKLrt4d+bGuicASvYMn/YA8ybdIwYSQJ0lTBkIU75FUDvq93Em0RWu
         41tBtjS7vxPlLEHpZ95tjXlVTTDhrX3+v8L5TdfJjZI7vbGyQXNPk/YRj29D5a6l9b
         4et8gI4pc706ysySebXw0WAJGy3CrqdSOUtPrUqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 064/343] drm/etnaviv: NULL vs IS_ERR() buf in etnaviv_core_dump()
Date:   Fri, 24 Jan 2020 10:28:02 +0100
Message-Id: <20200124092928.229078983@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f8261c376e7f8cb9024af5a6c54be540c7f9108e ]

The etnaviv_gem_get_pages() never returns NULL.  It returns error
pointers on error.

Fixes: a8c21a5451d8 ("drm/etnaviv: add initial etnaviv DRM driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_dump.c b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
index 2d955d7d7b6d8..e154e6fb64dac 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -207,7 +207,7 @@ void etnaviv_core_dump(struct etnaviv_gpu *gpu)
 		mutex_lock(&obj->lock);
 		pages = etnaviv_gem_get_pages(obj);
 		mutex_unlock(&obj->lock);
-		if (pages) {
+		if (!IS_ERR(pages)) {
 			int j;
 
 			iter.hdr->data[0] = bomap - bomap_start;
-- 
2.20.1



