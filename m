Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A133D5FE1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbhGZPTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236110AbhGZPT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:19:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B07C60F38;
        Mon, 26 Jul 2021 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315193;
        bh=6O/R5/EgTsRzWUbbEhc/kjHA1H6B4O4IbMck1UQPpaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0vSnO4rnBjyQbejbUGmkbr+6PUzWFgtfK2Caa8EnRhHBflhg9EMsBDnJCcq4cWbe
         EUsxOGYUBt/pGTFE0wtpQlnH2wp+oShWj96aDurXuDNM2E3OCqhbhRtvUtUHztWWQM
         1SDMxjtTcREHqGyQCfAaw2z/6QtJYFOMuzNza5Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charles Baylis <cb-kernel@fishzet.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.4 100/108] drm: Return -ENOTTY for non-drm ioctls
Date:   Mon, 26 Jul 2021 17:39:41 +0200
Message-Id: <20210726153834.885830076@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
@@ -826,6 +826,9 @@ long drm_ioctl(struct file *filp,
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


