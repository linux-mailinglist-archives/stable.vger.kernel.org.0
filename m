Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D012F649
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfE3Eyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbfE3DKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 258EB24493;
        Thu, 30 May 2019 03:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185820;
        bh=3RCxgWEyXcSUgOh3L8bO5IkpkOryQ3Q4vhOf9zYAuZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWUiY/8Eg1WJPe/knam2yaEdyJ3MmDatUps7OnuYwpZ9bHk4HQWBFJGdfhpMw4cBc
         mk5Oo2tt8WLxTqre0jZ0xsQaJyfhuKWz0dw1i1S+HadNYCnyC6IjLYIwvzkd+My9gd
         lpEKn/PezjRQBRjmEueDyvCiE3EbmyE8mfOOK5+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        "James Qian Wang (Arm Technology China)" <james.qian.wang@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 116/405] drm: prefix header search paths with $(srctree)/
Date:   Wed, 29 May 2019 20:01:54 -0700
Message-Id: <20190530030546.869328633@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 43068cb7ba1f6ceb1523e947c84002b2a61fd6d4 ]

Currently, the Kbuild core manipulates header search paths in a crazy
way [1].

To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
the search paths in the srctree. Some Makefiles are already written in
that way, but not all. The goal of this work is to make the notation
consistent, and finally get rid of the gross hacks.

Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
("kbuild: do not drop -I without parameter").

[1]: https://patchwork.kernel.org/patch/9632347/

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: James Qian Wang (Arm Technology China) <james.qian.wang@arm.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1553859161-2628-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/Makefile         | 2 +-
 drivers/gpu/drm/arm/display/komeda/Makefile | 4 ++--
 drivers/gpu/drm/i915/gvt/Makefile           | 2 +-
 drivers/gpu/drm/msm/Makefile                | 6 +++---
 drivers/gpu/drm/nouveau/Kbuild              | 8 ++++----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/Makefile b/drivers/gpu/drm/amd/amdgpu/Makefile
index 466da5954a682..62bf9da25e4b3 100644
--- a/drivers/gpu/drm/amd/amdgpu/Makefile
+++ b/drivers/gpu/drm/amd/amdgpu/Makefile
@@ -23,7 +23,7 @@
 # Makefile for the drm device driver.  This driver provides support for the
 # Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
 
-FULL_AMD_PATH=$(src)/..
+FULL_AMD_PATH=$(srctree)/$(src)/..
 DISPLAY_FOLDER_NAME=display
 FULL_AMD_DISPLAY_PATH = $(FULL_AMD_PATH)/$(DISPLAY_FOLDER_NAME)
 
diff --git a/drivers/gpu/drm/arm/display/komeda/Makefile b/drivers/gpu/drm/arm/display/komeda/Makefile
index 1b875e5dc0f6f..a72e30c0e03d3 100644
--- a/drivers/gpu/drm/arm/display/komeda/Makefile
+++ b/drivers/gpu/drm/arm/display/komeda/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ccflags-y := \
-	-I$(src)/../include \
-	-I$(src)
+	-I $(srctree)/$(src)/../include \
+	-I $(srctree)/$(src)
 
 komeda-y := \
 	komeda_drv.o \
diff --git a/drivers/gpu/drm/i915/gvt/Makefile b/drivers/gpu/drm/i915/gvt/Makefile
index 271fb46d4dd0d..ea8324abc784a 100644
--- a/drivers/gpu/drm/i915/gvt/Makefile
+++ b/drivers/gpu/drm/i915/gvt/Makefile
@@ -5,5 +5,5 @@ GVT_SOURCE := gvt.o aperture_gm.o handlers.o vgpu.o trace_points.o firmware.o \
 	execlist.o scheduler.o sched_policy.o mmio_context.o cmd_parser.o debugfs.o \
 	fb_decoder.o dmabuf.o page_track.o
 
-ccflags-y				+= -I$(src) -I$(src)/$(GVT_DIR)
+ccflags-y				+= -I $(srctree)/$(src) -I $(srctree)/$(src)/$(GVT_DIR)/
 i915-y					+= $(addprefix $(GVT_DIR)/, $(GVT_SOURCE))
diff --git a/drivers/gpu/drm/msm/Makefile b/drivers/gpu/drm/msm/Makefile
index 56a70c74af4ed..b7b1ebdc81902 100644
--- a/drivers/gpu/drm/msm/Makefile
+++ b/drivers/gpu/drm/msm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
-ccflags-y := -Idrivers/gpu/drm/msm
-ccflags-y += -Idrivers/gpu/drm/msm/disp/dpu1
-ccflags-$(CONFIG_DRM_MSM_DSI) += -Idrivers/gpu/drm/msm/dsi
+ccflags-y := -I $(srctree)/$(src)
+ccflags-y += -I $(srctree)/$(src)/disp/dpu1
+ccflags-$(CONFIG_DRM_MSM_DSI) += -I $(srctree)/$(src)/dsi
 
 msm-y := \
 	adreno/adreno_device.o \
diff --git a/drivers/gpu/drm/nouveau/Kbuild b/drivers/gpu/drm/nouveau/Kbuild
index 581404e6544d4..378c5dd692b0b 100644
--- a/drivers/gpu/drm/nouveau/Kbuild
+++ b/drivers/gpu/drm/nouveau/Kbuild
@@ -1,7 +1,7 @@
-ccflags-y += -I$(src)/include
-ccflags-y += -I$(src)/include/nvkm
-ccflags-y += -I$(src)/nvkm
-ccflags-y += -I$(src)
+ccflags-y += -I $(srctree)/$(src)/include
+ccflags-y += -I $(srctree)/$(src)/include/nvkm
+ccflags-y += -I $(srctree)/$(src)/nvkm
+ccflags-y += -I $(srctree)/$(src)
 
 # NVKM - HW resource manager
 #- code also used by various userspace tools/tests
-- 
2.20.1



