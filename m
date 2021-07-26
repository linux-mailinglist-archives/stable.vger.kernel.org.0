Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2873D6114
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhGZP21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237793AbhGZPZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BCD360F5E;
        Mon, 26 Jul 2021 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315583;
        bh=1NWY3vav1js9Y7AjIX2vb6yfLNkQhJwq9ZZ2rNKPgUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRwPWALbMC+CKWATIaNqx1suuJ6dm6Wnu0A3tDZ5d35IHGAZGIVmwm7KBzS95koQP
         4Z4JVC7kAWPPw52SSxjMBBPqHg+crQODkoE5f1Lc/0QWeqWK9JlOLfnrCRNbA1J1Sr
         mxPey7vmZDImlTy98IgGEk+ELcbWDfxEbBNyudZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charles Baylis <cb-kernel@fishzet.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.10 155/167] drm: Return -ENOTTY for non-drm ioctls
Date:   Mon, 26 Jul 2021 17:39:48 +0200
Message-Id: <20210726153844.612643287@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Baylis <cb-kernel@fishzet.co.uk>

commit 3abab27c322e0f2acf981595aa8040c9164dc9fb upstream.

drm: Return -ENOTTY for non-drm ioctls

Return -ENOTTY from drm_ioctl() when userspace passes in a cmd number
which doesn't relate to the drm subsystem.

Glibc uses the TCGETS ioctl to implement isatty(), and without this
change isatty() returns it incorrectly returns true for drm devices.

To test run this command:
$ if [ -t 0 ]; then echo is a tty; fi < /dev/dri/card0
which shows "is a tty" without this patch.

This may also modify memory which the userspace application is not
expecting.

Signed-off-by: Charles Baylis <cb-kernel@fishzet.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/YPG3IBlzaMhfPqCr@stando.fishzet.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_ioctl.c |    3 +++
 include/drm/drm_ioctl.h     |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -827,6 +827,9 @@ long drm_ioctl(struct file *filp,
 	if (drm_dev_is_unplugged(dev))
 		return -ENODEV;
 
+       if (DRM_IOCTL_TYPE(cmd) != DRM_IOCTL_BASE)
+               return -ENOTTY;
+
 	is_driver_ioctl = nr >= DRM_COMMAND_BASE && nr < DRM_COMMAND_END;
 
 	if (is_driver_ioctl) {
--- a/include/drm/drm_ioctl.h
+++ b/include/drm/drm_ioctl.h
@@ -68,6 +68,7 @@ typedef int drm_ioctl_compat_t(struct fi
 			       unsigned long arg);
 
 #define DRM_IOCTL_NR(n)                _IOC_NR(n)
+#define DRM_IOCTL_TYPE(n)              _IOC_TYPE(n)
 #define DRM_MAJOR       226
 
 /**


