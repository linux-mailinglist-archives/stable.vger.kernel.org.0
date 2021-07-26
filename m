Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3443D5F2E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbhGZPRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236906AbhGZPPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A5C6101E;
        Mon, 26 Jul 2021 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314880;
        bh=J0TFvrvPXgzTM3EvxtMcT/I8V9rN3rAA41WRPDYEV0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8iR3gXt33IF5Cp1+WOG0akgX/hy7AexA0ZgTFIvb30R1IIKUYyz+YwI5FJb7q71r
         9T3LdhOB1Zruw2y7ZJeFsDnUNr9D1ZgnjQIR6TCfZH7b7TWsG2HKs6n+Gm3ly+HrAk
         HGXnpibe3qMibT7Lp3fFtiDutClBYrY5rCZJp4Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charles Baylis <cb-kernel@fishzet.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.19 110/120] drm: Return -ENOTTY for non-drm ioctls
Date:   Mon, 26 Jul 2021 17:39:22 +0200
Message-Id: <20210726153835.996019832@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
@@ -797,6 +797,9 @@ long drm_ioctl(struct file *filp,
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


