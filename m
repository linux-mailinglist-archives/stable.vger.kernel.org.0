Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8915E6DE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405070AbgBNQTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:19:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405065AbgBNQTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FA002471D;
        Fri, 14 Feb 2020 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697192;
        bh=5GAH1D31Jg6YN2y96DofgQKtwEufW/I2MEgvZT31F00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mqr/zQ/jLUPrSN5TSyTdLf0xcmnv6px3W9dnvFdXvhjHct0/2hisj/E4uQStoNNcQ
         Z6MDcnAc/1wDOSWMKxb5hu2NYZ6PFrFEYYDZUKPkhEOiQsRgBLR33WF0LwltWku1Mi
         E7sgDIR1dVFI3gf9OQziJLPXLDhQ+BntP9WfBPwc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Schwartz <kern.simon@theschwartz.xyz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 121/186] driver core: platform: Prevent resouce overflow from causing infinite loops
Date:   Fri, 14 Feb 2020 11:16:10 -0500
Message-Id: <20200214161715.18113-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Schwartz <kern.simon@theschwartz.xyz>

[ Upstream commit 39cc539f90d035a293240c9443af50be55ee81b8 ]

num_resources in the platform_device struct is declared as a u32.  The
for loops that iterate over num_resources use an int as the counter,
which can cause infinite loops on architectures with smaller ints.
Change the loop counters to u32.

Signed-off-by: Simon Schwartz <kern.simon@theschwartz.xyz>
Link: https://lore.kernel.org/r/2201ce63a2a171ffd2ed14e867875316efcf71db.camel@theschwartz.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f1105de0d9fed..e3d40c41c33b0 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -28,6 +28,7 @@
 #include <linux/limits.h>
 #include <linux/property.h>
 #include <linux/kmemleak.h>
+#include <linux/types.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -68,7 +69,7 @@ void __weak arch_setup_pdev_archdata(struct platform_device *pdev)
 struct resource *platform_get_resource(struct platform_device *dev,
 				       unsigned int type, unsigned int num)
 {
-	int i;
+	u32 i;
 
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];
@@ -163,7 +164,7 @@ struct resource *platform_get_resource_byname(struct platform_device *dev,
 					      unsigned int type,
 					      const char *name)
 {
-	int i;
+	u32 i;
 
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];
@@ -360,7 +361,8 @@ EXPORT_SYMBOL_GPL(platform_device_add_properties);
  */
 int platform_device_add(struct platform_device *pdev)
 {
-	int i, ret;
+	u32 i;
+	int ret;
 
 	if (!pdev)
 		return -EINVAL;
@@ -447,7 +449,7 @@ EXPORT_SYMBOL_GPL(platform_device_add);
  */
 void platform_device_del(struct platform_device *pdev)
 {
-	int i;
+	u32 i;
 
 	if (pdev) {
 		device_remove_properties(&pdev->dev);
-- 
2.20.1

