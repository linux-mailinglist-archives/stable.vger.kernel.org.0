Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348F53C4832
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhGLGgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236714AbhGLGf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 896FF610CC;
        Mon, 12 Jul 2021 06:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071555;
        bh=EKY1OlRJO93TJiFmqfgVZB3HH1bgpwa6v7NyZcI16Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUXm6etrK2iO0esrCcGBqoxQzFE/nUL4789gUqEZ74wmW6Ytw9uKCYygXH6fktGYn
         XMpH3aGRvhc3dUSIyH9U3j56TghBKOH5SH6LP7uWtUYtVAQlvkywpTHQVpmMgf6W5S
         HcU0mmtpIqd8yFSs5B0lIKoeFj2IG+B6USf2I6x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/593] media: sti: fix obj-$(config) targets
Date:   Mon, 12 Jul 2021 08:04:41 +0200
Message-Id: <20210712060856.461874391@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 56c1f0876293888f686e31278d183d4af2cac3c3 ]

The right thing to do is to add a new object to the building
system when a certain config option is selected, and *not*
override them.

So, fix obj-$(config) logic at sti makefiles, using "+=",
instead of ":=".

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/bdisp/Makefile | 2 +-
 drivers/media/platform/sti/delta/Makefile | 2 +-
 drivers/media/platform/sti/hva/Makefile   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/Makefile b/drivers/media/platform/sti/bdisp/Makefile
index caf7ccd193ea..39ade0a34723 100644
--- a/drivers/media/platform/sti/bdisp/Makefile
+++ b/drivers/media/platform/sti/bdisp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_VIDEO_STI_BDISP) := bdisp.o
+obj-$(CONFIG_VIDEO_STI_BDISP) += bdisp.o
 
 bdisp-objs := bdisp-v4l2.o bdisp-hw.o bdisp-debug.o
diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
index 92b37e216f00..32412fa4c632 100644
--- a/drivers/media/platform/sti/delta/Makefile
+++ b/drivers/media/platform/sti/delta/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_VIDEO_STI_DELTA_DRIVER) := st-delta.o
+obj-$(CONFIG_VIDEO_STI_DELTA_DRIVER) += st-delta.o
 st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o delta-debug.o
 
 # MJPEG support
diff --git a/drivers/media/platform/sti/hva/Makefile b/drivers/media/platform/sti/hva/Makefile
index 74b41ec52f97..b5a5478bdd01 100644
--- a/drivers/media/platform/sti/hva/Makefile
+++ b/drivers/media/platform/sti/hva/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_VIDEO_STI_HVA) := st-hva.o
+obj-$(CONFIG_VIDEO_STI_HVA) += st-hva.o
 st-hva-y := hva-v4l2.o hva-hw.o hva-mem.o hva-h264.o
 st-hva-$(CONFIG_VIDEO_STI_HVA_DEBUGFS) += hva-debugfs.o
-- 
2.30.2



