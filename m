Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B317147FE4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388328AbgAXLGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732644AbgAXLGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:06:04 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EEA120663;
        Fri, 24 Jan 2020 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863963;
        bh=FEz5wwYgE1K+I9svTO2hpZMPGr485rBFku3mYnXeNlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZDYGFHf567w7wldtP4LCVpZ12RwkefOXKP2MtpOcuILsqGPkk5FvLIv6/M81xHLf
         /Q3TdLEO5P+XlBrMIsNWxIlWT/ctlCeS6vUnIjTSbIOZx7pOCwKY1V76brEYyn+ef4
         FJ7fYoNTIfcJY1j6IgXiX9GmqTbrPuqar8XcLlJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/639] drm/etnaviv: NULL vs IS_ERR() buf in etnaviv_core_dump()
Date:   Fri, 24 Jan 2020 10:25:03 +0100
Message-Id: <20200124093103.939996199@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index 468dff2f79040..9d839b4fd8f78 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -217,7 +217,7 @@ void etnaviv_core_dump(struct etnaviv_gpu *gpu)
 		mutex_lock(&obj->lock);
 		pages = etnaviv_gem_get_pages(obj);
 		mutex_unlock(&obj->lock);
-		if (pages) {
+		if (!IS_ERR(pages)) {
 			int j;
 
 			iter.hdr->data[0] = bomap - bomap_start;
-- 
2.20.1



