Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E95B2A5589
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgKCVTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388355AbgKCVHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:07:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEF82205ED;
        Tue,  3 Nov 2020 21:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437672;
        bh=d6BMHzK4XpMulQAyPTS2drc2oo+njpraHmLdyy4Jkz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLYRfiVYJqubH/4QveLCa0E2JC0AVHg549IitzB/b0TZ7flQi1sXCjRakY7V5n3FQ
         aCBeYXxAZ4HFZl2PRlpVfs0oCyWxF1BrtuLsYuWIKyt3Ly96JNnwn5jSI1uQgK/CYN
         LIualF+zJGrtG/IW2MzjsRFML4NpNb1vOTiAwgBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 4.19 177/191] drm/ttm: fix eviction valuable range check.
Date:   Tue,  3 Nov 2020 21:37:49 +0100
Message-Id: <20201103203249.196811678@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit fea456d82c19d201c21313864105876deabe148b upstream.

This was adding size to start, but pfn and start are in pages,
so it should be using num_pages.

Not sure this fixes anything in the real world, just noticed it
during refactoring.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20201019222257.1684769-2-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -671,7 +671,7 @@ bool ttm_bo_eviction_valuable(struct ttm
 	/* Don't evict this BO if it's outside of the
 	 * requested placement range
 	 */
-	if (place->fpfn >= (bo->mem.start + bo->mem.size) ||
+	if (place->fpfn >= (bo->mem.start + bo->mem.num_pages) ||
 	    (place->lpfn && place->lpfn <= bo->mem.start))
 		return false;
 


