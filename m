Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3962A57CE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731998AbgKCUvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgKCUvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 256352071E;
        Tue,  3 Nov 2020 20:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436710;
        bh=TLQXn4pmUjcvNk1YPYPQecF335j53y2AyGsM+J010d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpL74lDM8Pqe7b8WQFUvRDqSeLQ8lFjCaFy/05rq2Er5IcJxb28Opi8TwzEkmVL3I
         6rPMoVLz+bXXh9Vo+lm+kFWMvnlKbtynTxGWC/FYVTF97t+/AWizkPyR5QOqE92w93
         e6WwtDfsTLHYsTD7ghcJxJuWtXIF4Z13TzuhSk0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.9 369/391] ARM: config: aspeed: Fix selection of media drivers
Date:   Tue,  3 Nov 2020 21:37:00 +0100
Message-Id: <20201103203412.047213504@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

commit 98c3f0a1b3ef83f6be6b212c970bee795e1a0467 upstream.

In the 5.7 merge window the media kconfig was restructued. For most
platforms these changes set CONFIG_MEDIA_SUPPORT_FILTER=y which keeps
unwanted drivers disabled.

The exception is if a config sets EMBEDDED or EXPERT (see b0cd4fb27665).
In that case the filter is set to =n, causing a bunch of DVB tuner drivers
(MEDIA_TUNER_*) to be accidentally enabled. This was noticed as it blew
out the build time for the Aspeed defconfigs.

Enabling the filter means the Aspeed config also needs to set
CONFIG_MEDIA_PLATFORM_SUPPORT=y in order to have the CONFIG_VIDEO_ASPEED
driver enabled.

Fixes: 06b93644f4d1 ("media: Kconfig: add an option to filter in/out platform drivers")
Fixes: b0cd4fb27665 ("media: Kconfig: on !EMBEDDED && !EXPERT, enable driver filtering")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Cc: stable@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/aspeed_g4_defconfig |    3 ++-
 arch/arm/configs/aspeed_g5_defconfig |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/configs/aspeed_g4_defconfig
+++ b/arch/arm/configs/aspeed_g4_defconfig
@@ -160,7 +160,8 @@ CONFIG_SENSORS_TMP421=y
 CONFIG_SENSORS_W83773G=y
 CONFIG_WATCHDOG_SYSFS=y
 CONFIG_MEDIA_SUPPORT=y
-CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_MEDIA_SUPPORT_FILTER=y
+CONFIG_MEDIA_PLATFORM_SUPPORT=y
 CONFIG_V4L_PLATFORM_DRIVERS=y
 CONFIG_VIDEO_ASPEED=y
 CONFIG_DRM=y
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -175,7 +175,8 @@ CONFIG_SENSORS_TMP421=y
 CONFIG_SENSORS_W83773G=y
 CONFIG_WATCHDOG_SYSFS=y
 CONFIG_MEDIA_SUPPORT=y
-CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_MEDIA_SUPPORT_FILTER=y
+CONFIG_MEDIA_PLATFORM_SUPPORT=y
 CONFIG_V4L_PLATFORM_DRIVERS=y
 CONFIG_VIDEO_ASPEED=y
 CONFIG_DRM=y


