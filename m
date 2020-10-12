Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAA28B9C9
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390436AbgJLODr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgJLNgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B46452076E;
        Mon, 12 Oct 2020 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509790;
        bh=Uqcssya3qJQURCLZ5TZcMKCc+eeib0YtWVFfrFHR1vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbjWU33o/WbW+8zviYWmpZjCXLeO+fOQWwOp69Jrs5I7TcLqoaaTI+F8tH2HnmJCq
         a7BuKqAPPGUK4h35sjPs6ImDT5h5m/poCYK+VIoLrNOA52pIMVn71Bok6/SEo6xfYJ
         by8Wcd36UDjUPP0kTJyCvMEjWcC7AyqdBNE8FCWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.14 31/70] drm/syncobj: Fix drm_syncobj_handle_to_fd refcount leak
Date:   Mon, 12 Oct 2020 15:26:47 +0200
Message-Id: <20201012132631.677832766@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giuliano Procida <gprocida@google.com>

Commit 5fb252cad61f20ae5d5a8b199f6cc4faf6f418e1, a cherry-pick of
upstream commit e7cdf5c82f1773c3386b93bbcf13b9bfff29fa31, introduced a
refcount imbalance and thus a struct drm_syncobj object leak which can
be triggered with DRM_IOCTL_SYNCOBJ_HANDLE_TO_FD.

The function drm_syncobj_handle_to_fd first calls drm_syncobj_find
which increments the refcount of the object on success. In all of the
drm_syncobj_handle_to_fd error paths, the refcount is decremented, but
in the success path the refcount should remain at +1 as the struct
drm_syncobj now belongs to the newly opened file. Instead, the
refcount was incremented again to +2.

Fixes: 5fb252cad61f ("drm/syncobj: Stop reusing the same struct file for all syncobj -> fd")
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_syncobj.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -355,7 +355,6 @@ static int drm_syncobj_handle_to_fd(stru
 		return PTR_ERR(file);
 	}
 
-	drm_syncobj_get(syncobj);
 	fd_install(fd, file);
 
 	*p_fd = fd;


