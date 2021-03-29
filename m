Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBD234C83F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhC2IVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhC2IUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D36661477;
        Mon, 29 Mar 2021 08:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006009;
        bh=O6tClAaFA0Qq72nsz5l4iwyHAcp7i0MbnyNKYGoJMvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LP1Dd2e4FlNA2B6C6KOFUcAR90576ALlMC2DI9gdvIzsnE+hJrmc1DNh+wIE+jc3r
         tyWDVt/4yuhkT8/Qf1J6HKcWoI0b3MRqELWcjUEamsdskJGjDpUdEDFKlRY/I9hmMR
         3mTFflgUEDjl4Mfui1DcVsIEqBgmAtGqwDCroUro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        etnaviv@lists.freedesktop.org
Subject: [PATCH 5.10 084/221] drm/etnaviv: Use FOLL_FORCE for userptr
Date:   Mon, 29 Mar 2021 09:56:55 +0200
Message-Id: <20210329075632.011485061@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit cd5297b0855f17c8b4e3ef1d20c6a3656209c7b3 upstream.

Nothing checks userptr.ro except this call to pup_fast, which means
there's nothing actually preventing userspace from writing to this.
Which means you can just read-only mmap any file you want, userptr it
and then write to it with the gpu. Not good.

The right way to handle this is FOLL_WRITE | FOLL_FORCE, which will
break any COW mappings and update tracking for MAY_WRITE mappings so
there's no exploit and the vm isn't confused about what's going on.
For any legit use case there's no difference from what userspace can
observe and do.

Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Cc: stable@vger.kernel.org
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Russell King <linux+etnaviv@armlinux.org.uk>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: etnaviv@lists.freedesktop.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210301095254.1946084-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -675,7 +675,7 @@ static int etnaviv_gem_userptr_get_pages
 		struct page **pages = pvec + pinned;
 
 		ret = pin_user_pages_fast(ptr, num_pages,
-					  !userptr->ro ? FOLL_WRITE : 0, pages);
+					  FOLL_WRITE | FOLL_FORCE, pages);
 		if (ret < 0) {
 			unpin_user_pages(pvec, pinned);
 			kvfree(pvec);


