Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4932A54B0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389352AbgKCVNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389341AbgKCVNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42AF620757;
        Tue,  3 Nov 2020 21:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604438025;
        bh=OX8b5EYQe+b95zAF2JHuthkCUFe9Iuso79cVvXTmIyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqCNtm+5WYvV6xvuwK8gVQDhUvyL3C5TZfKN3JwHn3JR2gorvDVEZSYMEmqmPE8OJ
         59vxrlG+qJvPgcsq1sHpr6H99/e5gZL8ZEPNWQvZfP7MNiP9qfni0fBezVHRshKU4X
         1G62lz7zFVr7fTgFAQbk2BaY4+iF06AZ1VnDMyPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 4.14 111/125] drm/ttm: fix eviction valuable range check.
Date:   Tue,  3 Nov 2020 21:38:08 +0100
Message-Id: <20201103203213.604378448@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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
@@ -721,7 +721,7 @@ bool ttm_bo_eviction_valuable(struct ttm
 	/* Don't evict this BO if it's outside of the
 	 * requested placement range
 	 */
-	if (place->fpfn >= (bo->mem.start + bo->mem.size) ||
+	if (place->fpfn >= (bo->mem.start + bo->mem.num_pages) ||
 	    (place->lpfn && place->lpfn <= bo->mem.start))
 		return false;
 


