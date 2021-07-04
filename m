Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A373BB0AA
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhGDXJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhGDXIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BE3F61483;
        Sun,  4 Jul 2021 23:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439973;
        bh=xX8VyNOodZXaJbZ6Zo8s39DpvovzD6FKkh4MDY9d7wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0ZqdhlHjt4jQK2YfKMXwbXTwF42Ve6FX5tRO4+EXpsuZ80DcalIwGQXuADujB2Ly
         1y6jUexqJWJ1F67PtYzHdX2QZBcYqRghXECAOrSDZ8yPiMFHd4EN81XNa3cvzj4+M7
         5rrKQczQ+9to1uuwrGjSZi+pi1U2oRlHsYPSRbJSO1PtI7VnCaf207E91O0SMcHLpZ
         5jmb4lQj6pfrxORjhy3nCS/fnYvIOCyNeQ9I3xB8T7X7Hl/PKYWRUSDCr2qGVWKHuN
         MyjA+si174EucCu6M5BT1xja/WdbUlXRkojhQUXB0jvz/vZ6pHFklMEzTTelr/j+ng
         6Vx1pYoQkQISg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 84/85] media: Fix Media Controller API config checks
Date:   Sun,  4 Jul 2021 19:04:19 -0400
Message-Id: <20210704230420.1488358-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 50e7a31d30e8221632675abed3be306382324ca2 ]

Smatch static checker warns that "mdev" can be null:

sound/usb/media.c:287 snd_media_device_create()
    warn: 'mdev' can also be NULL

If CONFIG_MEDIA_CONTROLLER is disabled, this file should not be included
in the build.

The below conditions in the sound/usb/Makefile are in place to ensure that
media.c isn't included in the build.

sound/usb/Makefile:
snd-usb-audio-$(CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER) += media.o

select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER &&
       (MEDIA_SUPPORT=y || MEDIA_SUPPORT=SND_USB_AUDIO)

The following config check in include/media/media-dev-allocator.h is
in place to enable the API only when CONFIG_MEDIA_CONTROLLER and
CONFIG_USB are enabled.

 #if defined(CONFIG_MEDIA_CONTROLLER) && defined(CONFIG_USB)

This check doesn't work as intended when CONFIG_USB=m. When CONFIG_USB=m,
CONFIG_USB_MODULE is defined and CONFIG_USB is not. The above config check
doesn't catch that CONFIG_USB is defined as a module and disables the API.
This results in sound/usb enabling Media Controller specific ALSA driver
code, while Media disables the Media Controller API.

Fix the problem requires two changes:

1. Change the check to use IS_ENABLED to detect when CONFIG_USB is enabled
   as a module or static. Since CONFIG_MEDIA_CONTROLLER is a bool, leave
   the check unchanged to be consistent with drivers/media/Makefile.

2. Change the drivers/media/mc/Makefile to include mc-dev-allocator.o
   in mc-objs when CONFIG_USB is enabled.

Link: https://lore.kernel.org/alsa-devel/YLeAvT+R22FQ%2FEyw@mwanda/

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/mc/Makefile           | 2 +-
 include/media/media-dev-allocator.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/mc/Makefile b/drivers/media/mc/Makefile
index 119037f0e686..2b7af42ba59c 100644
--- a/drivers/media/mc/Makefile
+++ b/drivers/media/mc/Makefile
@@ -3,7 +3,7 @@
 mc-objs	:= mc-device.o mc-devnode.o mc-entity.o \
 	   mc-request.o
 
-ifeq ($(CONFIG_USB),y)
+ifneq ($(CONFIG_USB),)
 	mc-objs += mc-dev-allocator.o
 endif
 
diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
index b35ea6062596..2ab54d426c64 100644
--- a/include/media/media-dev-allocator.h
+++ b/include/media/media-dev-allocator.h
@@ -19,7 +19,7 @@
 
 struct usb_device;
 
-#if defined(CONFIG_MEDIA_CONTROLLER) && defined(CONFIG_USB)
+#if defined(CONFIG_MEDIA_CONTROLLER) && IS_ENABLED(CONFIG_USB)
 /**
  * media_device_usb_allocate() - Allocate and return struct &media device
  *
-- 
2.30.2

