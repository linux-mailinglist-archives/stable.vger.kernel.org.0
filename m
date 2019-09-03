Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15970A70A6
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbfICQju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730389AbfICQZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A7D2343A;
        Tue,  3 Sep 2019 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527927;
        bh=wwerqmC3bXh4Yc8fQeoW4IUNyVQ9Cmz2XuGCLkZv53M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4OzAUV2zqefL4HTF9sHrIicZgmhZa2xwebA4QB8yiD/b/4QxULp9ro2u9DXqUCFw
         2xjLrVFBScUpeiPsZkLB2YySZ76CbIOq7+K6p9SjnC1Oju6bXv4dtTh4rJAVvEASct
         ezvfU/hUI2qwgD8eqGVYGRz+0zc663CnReKMUeA0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 003/167] media: cec: remove cec-edid.c
Date:   Tue,  3 Sep 2019 12:22:35 -0400
Message-Id: <20190903162519.7136-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

[ Upstream commit f94d463f1b7f83d465ed77521821583dbcdaa3c5 ]

Move cec_get_edid_phys_addr() to cec-adap.c. It's not worth keeping
a separate source for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.17 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/Makefile   |  2 +-
 drivers/media/cec/cec-adap.c | 13 +++++++++++++
 drivers/media/cec/cec-edid.c | 24 ------------------------
 3 files changed, 14 insertions(+), 25 deletions(-)
 delete mode 100644 drivers/media/cec/cec-edid.c

diff --git a/drivers/media/cec/Makefile b/drivers/media/cec/Makefile
index 29a2ab9e77c5d..ad8677d8c8967 100644
--- a/drivers/media/cec/Makefile
+++ b/drivers/media/cec/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-cec-objs := cec-core.o cec-adap.o cec-api.o cec-edid.o
+cec-objs := cec-core.o cec-adap.o cec-api.o
 
 ifeq ($(CONFIG_CEC_NOTIFIER),y)
   cec-objs += cec-notifier.o
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index a7ea27d2aa8ef..4a15d53f659ec 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -62,6 +62,19 @@ static unsigned int cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr
 	return adap->log_addrs.primary_device_type[i < 0 ? 0 : i];
 }
 
+u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			   unsigned int *offset)
+{
+	unsigned int loc = cec_get_edid_spa_location(edid, size);
+
+	if (offset)
+		*offset = loc;
+	if (loc == 0)
+		return CEC_PHYS_ADDR_INVALID;
+	return (edid[loc] << 8) | edid[loc + 1];
+}
+EXPORT_SYMBOL_GPL(cec_get_edid_phys_addr);
+
 /*
  * Queue a new event for this filehandle. If ts == 0, then set it
  * to the current time.
diff --git a/drivers/media/cec/cec-edid.c b/drivers/media/cec/cec-edid.c
deleted file mode 100644
index e2f54eec08294..0000000000000
--- a/drivers/media/cec/cec-edid.c
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * cec-edid - HDMI Consumer Electronics Control EDID & CEC helper functions
- *
- * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <media/cec.h>
-
-u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
-			   unsigned int *offset)
-{
-	unsigned int loc = cec_get_edid_spa_location(edid, size);
-
-	if (offset)
-		*offset = loc;
-	if (loc == 0)
-		return CEC_PHYS_ADDR_INVALID;
-	return (edid[loc] << 8) | edid[loc + 1];
-}
-EXPORT_SYMBOL_GPL(cec_get_edid_phys_addr);
-- 
2.20.1

