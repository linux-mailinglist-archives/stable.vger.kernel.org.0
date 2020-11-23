Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8BA2C0701
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbgKWMga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731699AbgKWMga (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:36:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F052065E;
        Mon, 23 Nov 2020 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134989;
        bh=NDiwTZ+Yy4EQL78bDKUvx5rt4xEaVpYvsuF9xd2hvTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XX7OYv+V83k5tFrCvVHN7XUhPNqsBYRWS/5WW4pwun+EvttXsEF1/Tvld7xaaLEuy
         Ka90v9X8SzmIT8QGYsjTfU/H+b/hls1664GR+Qm4fPOKjj38JzWj8asVmYpPUvpC2f
         aSM2zsAj5Jv9I5CBquMtT7oUVgmD76kwp2ZFMxoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/158] swiotlb: using SIZE_MAX needs limits.h included
Date:   Mon, 23 Nov 2020 13:21:33 +0100
Message-Id: <20201123121823.072877964@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

[ Upstream commit f51778db088b2407ec177f2f4da0f6290602aa3f ]

After merging the drm-misc tree, linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from drivers/gpu/drm/nouveau/nouveau_ttm.c:26:
include/linux/swiotlb.h: In function 'swiotlb_max_mapping_size':
include/linux/swiotlb.h:99:9: error: 'SIZE_MAX' undeclared (first use in this function)
   99 |  return SIZE_MAX;
      |         ^~~~~~~~
include/linux/swiotlb.h:7:1: note: 'SIZE_MAX' is defined in header '<stdint.h>'; did you forget to '#include <stdint.h>'?
    6 | #include <linux/init.h>
  +++ |+#include <stdint.h>
    7 | #include <linux/types.h>
include/linux/swiotlb.h:99:9: note: each undeclared identifier is reported only once for each function it appears in
   99 |  return SIZE_MAX;
      |         ^~~~~~~~

Caused by commit

  abe420bfae52 ("swiotlb: Introduce swiotlb_max_mapping_size()")

but only exposed by commit "drm/nouveu: fix swiotlb include"

Fix it by including linux/limits.h as appropriate.

Fixes: abe420bfae52 ("swiotlb: Introduce swiotlb_max_mapping_size()")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/r/20201102124327.2f82b2a7@canb.auug.org.au
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swiotlb.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cde3dc18e21a2..0a8fced6aaec4 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -5,6 +5,7 @@
 #include <linux/dma-direction.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/limits.h>
 
 struct device;
 struct page;
-- 
2.27.0



