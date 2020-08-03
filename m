Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733DC23A57F
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgHCMho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbgHCMeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:34:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7929F20775;
        Mon,  3 Aug 2020 12:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458083;
        bh=mkl1060GsJT5092ivQ+WUBjOcwE8UnGLSafgYo2cPUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGXkrGveOb+8mxL9Kn5phnlEktnKiWbhfvXc9kl2SSgCmYW1GUipeplrHEYzCR9sK
         UaaIIGuC3egNW1n1iClpTxMlaJNN/2vEG6VsNwQebofcIJY5uuijP/uhweb4qc/Sl9
         th3km4zj9YdNypA9a90HkOsWAGpaSp9/cJGcH0/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Cohen <cohens@codeaurora.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.14 15/51] drm: hold gem reference until object is no longer accessed
Date:   Mon,  3 Aug 2020 14:20:00 +0200
Message-Id: <20200803121850.225770828@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Cohen <cohens@codeaurora.org>

commit 8490d6a7e0a0a6fab5c2d82d57a3937306660864 upstream.

A use-after-free in drm_gem_open_ioctl can happen if the
GEM object handle is closed between the idr lookup and
retrieving the size from said object since a local reference
is not being held at that point. Hold the local reference
while the object can still be accessed to fix this and
plug the potential security hole.

Signed-off-by: Steve Cohen <cohens@codeaurora.org>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1595284250-31580-1-git-send-email-cohens@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_gem.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -730,9 +730,6 @@ err:
  * @file_priv: drm file-private structure
  *
  * Open an object using the global name, returning a handle and the size.
- *
- * This handle (of course) holds a reference to the object, so the object
- * will not go away until the handle is deleted.
  */
 int
 drm_gem_open_ioctl(struct drm_device *dev, void *data,
@@ -757,14 +754,15 @@ drm_gem_open_ioctl(struct drm_device *de
 
 	/* drm_gem_handle_create_tail unlocks dev->object_name_lock. */
 	ret = drm_gem_handle_create_tail(file_priv, obj, &handle);
-	drm_gem_object_put_unlocked(obj);
 	if (ret)
-		return ret;
+		goto err;
 
 	args->handle = handle;
 	args->size = obj->size;
 
-	return 0;
+err:
+	drm_gem_object_put_unlocked(obj);
+	return ret;
 }
 
 /**


