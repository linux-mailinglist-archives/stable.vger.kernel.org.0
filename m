Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DAE2E666C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407871AbgL1QMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387967AbgL1NV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:21:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60598207C9;
        Mon, 28 Dec 2020 13:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161674;
        bh=zVhJz5NUX6hGPxi2AWc77kBUaBzn4WGc1q3gf0E/Xpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTzSdefijYiGsohz/r+ZPlkpZ4mM/+JRvTVi9NYEINQonQBI/hiLvcGWe08OLiWM8
         Kl44R7ci7fIBjk1SyvxuJCfxnvfxiBQAix9XPho4X0T7iqINIUkSzkadOeXupniMFb
         769u0YSQam/1Znah6Puq8q5NyIOMPdtpIDYZUsCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 048/346] drm/xen-front: Fix misused IS_ERR_OR_NULL checks
Date:   Mon, 28 Dec 2020 13:46:07 +0100
Message-Id: <20201228124922.112563517@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

commit 14dee058610446aa464254fc5c8e88c7535195e0 upstream

The patch c575b7eeb89f: "drm/xen-front: Add support for Xen PV
display frontend" from Apr 3, 2018, leads to the following static
checker warning:

	drivers/gpu/drm/xen/xen_drm_front_gem.c:140 xen_drm_front_gem_create()
	warn: passing zero to 'ERR_CAST'

drivers/gpu/drm/xen/xen_drm_front_gem.c
   133  struct drm_gem_object *xen_drm_front_gem_create(struct drm_device *dev,
   134                                                  size_t size)
   135  {
   136          struct xen_gem_object *xen_obj;
   137
   138          xen_obj = gem_create(dev, size);
   139          if (IS_ERR_OR_NULL(xen_obj))
   140                  return ERR_CAST(xen_obj);

Fix this and the rest of misused places with IS_ERR_OR_NULL in the
driver.

Fixes:  c575b7eeb89f: "drm/xen-front: Add support for Xen PV display frontend"

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200813062113.11030-3-andr2000@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xen/xen_drm_front.c     |    2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c |    8 ++++----
 drivers/gpu/drm/xen/xen_drm_front_kms.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -410,7 +410,7 @@ static int xen_drm_drv_dumb_create(struc
 	args->size = args->pitch * args->height;
 
 	obj = xen_drm_front_gem_create(dev, args->size);
-	if (IS_ERR_OR_NULL(obj)) {
+	if (IS_ERR(obj)) {
 		ret = PTR_ERR(obj);
 		goto fail;
 	}
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -85,7 +85,7 @@ static struct xen_gem_object *gem_create
 
 	size = round_up(size, PAGE_SIZE);
 	xen_obj = gem_create_obj(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return xen_obj;
 
 	if (drm_info->front_info->cfg.be_alloc) {
@@ -119,7 +119,7 @@ static struct xen_gem_object *gem_create
 	 */
 	xen_obj->num_pages = DIV_ROUND_UP(size, PAGE_SIZE);
 	xen_obj->pages = drm_gem_get_pages(&xen_obj->base);
-	if (IS_ERR_OR_NULL(xen_obj->pages)) {
+	if (IS_ERR(xen_obj->pages)) {
 		ret = PTR_ERR(xen_obj->pages);
 		xen_obj->pages = NULL;
 		goto fail;
@@ -138,7 +138,7 @@ struct drm_gem_object *xen_drm_front_gem
 	struct xen_gem_object *xen_obj;
 
 	xen_obj = gem_create(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return ERR_CAST(xen_obj);
 
 	return &xen_obj->base;
@@ -196,7 +196,7 @@ xen_drm_front_gem_import_sg_table(struct
 
 	size = attach->dmabuf->size;
 	xen_obj = gem_create_obj(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return ERR_CAST(xen_obj);
 
 	ret = gem_alloc_pages_array(xen_obj, size);
--- a/drivers/gpu/drm/xen/xen_drm_front_kms.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_kms.c
@@ -59,7 +59,7 @@ fb_create(struct drm_device *dev, struct
 	int ret;
 
 	fb = drm_gem_fb_create_with_funcs(dev, filp, mode_cmd, &fb_funcs);
-	if (IS_ERR_OR_NULL(fb))
+	if (IS_ERR(fb))
 		return fb;
 
 	gem_obj = drm_gem_object_lookup(filp, mode_cmd->handles[0]);


