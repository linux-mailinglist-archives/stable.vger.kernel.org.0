Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0971EAF1B
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgFAR5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728825AbgFAR5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA28207DF;
        Mon,  1 Jun 2020 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034225;
        bh=Sv50GhNdNfAEmQPgwJon282Ryl8sV1jtnma2waxrDZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LU+cS3QUqRQpaI0Y5Hk8AewS74OppJJIiEiLkbTqs1NpaiJ2pyNjnr1EALHf1pmqX
         yue6ZvXKJHCx7F+RoojtaSLIE3yF1jb+rl0xJBZLA+IjXxpecGirJOs1EJAklLMJFo
         2v0OkfR4k5JRy2H3DevylOSfYrOhuQATXt8BpVj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 48/48] drm/msm: Fix possible null dereference on failure of get_pages()
Date:   Mon,  1 Jun 2020 19:53:58 +0200
Message-Id: <20200601174005.784720752@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

commit 3976626ea3d2011f8fd3f3a47070a8b792018253 upstream.

Commit 62e3a3e342af changed get_pages() to initialise
msm_gem_object::pages before trying to initialise msm_gem_object::sgt,
so that put_pages() would properly clean up pages in the failure
case.

However, this means that put_pages() now needs to check that
msm_gem_object::sgt is not null before trying to clean it up, and
this check was only applied to part of the cleanup code.  Move
it all into the conditional block.  (Strictly speaking we don't
need to make the kfree() conditional, but since we can't avoid
checking for null ourselves we may as well do so.)

Fixes: 62e3a3e342af ("drm/msm: fix leak in failed get_pages")
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/msm_gem.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -116,17 +116,19 @@ static void put_pages(struct drm_gem_obj
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
 
 	if (msm_obj->pages) {
-		/* For non-cached buffers, ensure the new pages are clean
-		 * because display controller, GPU, etc. are not coherent:
-		 */
-		if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-			dma_unmap_sg(obj->dev->dev, msm_obj->sgt->sgl,
-					msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
+		if (msm_obj->sgt) {
+			/* For non-cached buffers, ensure the new
+			 * pages are clean because display controller,
+			 * GPU, etc. are not coherent:
+			 */
+			if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
+				dma_unmap_sg(obj->dev->dev, msm_obj->sgt->sgl,
+					     msm_obj->sgt->nents,
+					     DMA_BIDIRECTIONAL);
 
-		if (msm_obj->sgt)
 			sg_free_table(msm_obj->sgt);
-
-		kfree(msm_obj->sgt);
+			kfree(msm_obj->sgt);
+		}
 
 		if (use_pages(obj))
 			drm_gem_put_pages(obj, msm_obj->pages, true, false);


