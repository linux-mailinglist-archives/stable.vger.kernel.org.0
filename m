Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CBA1F2D1A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgFHXPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbgFHXPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 526592078B;
        Mon,  8 Jun 2020 23:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658120;
        bh=cL658tjAUDKGMd9q07eE3Ieo9f+l6YZLd8BqvCF2ifA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeIeOvUhOHKShqMN7CJgxTZf0E2IBBtI3OnmMcZO3TPtpbAMPaqTJrr45BA6sT2E3
         JuCG2ev7Za6MsNK7/x9EwhQb0onUfYm/7ivJWpSqKPxjBtSOBw0oUR2FYRtDfyP5An
         UoP9p3KiYZa5s7UM4mNNX9/4zTI2r4ELF9Gnx2MY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 157/606] drm/etnaviv: Fix a leak in submit_pin_objects()
Date:   Mon,  8 Jun 2020 19:04:42 -0400
Message-Id: <20200608231211.3363633-157-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ad99cb5e783bb03d512092db3387ead9504aad3d upstream.

If the mapping address is wrong then we have to release the reference to
it before returning -EINVAL.

Fixes: 088880ddc0b2 ("drm/etnaviv: implement softpin")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
index 3b0afa156d92..54def341c1db 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -238,8 +238,10 @@ static int submit_pin_objects(struct etnaviv_gem_submit *submit)
 		}
 
 		if ((submit->flags & ETNA_SUBMIT_SOFTPIN) &&
-		     submit->bos[i].va != mapping->iova)
+		     submit->bos[i].va != mapping->iova) {
+			etnaviv_gem_mapping_unreference(mapping);
 			return -EINVAL;
+		}
 
 		atomic_inc(&etnaviv_obj->gpu_active);
 
-- 
2.25.1

