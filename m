Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2EB491E22
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354790AbiARDrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:47:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58368 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347167AbiARCkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:40:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1652608C0;
        Tue, 18 Jan 2022 02:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1455C36AEB;
        Tue, 18 Jan 2022 02:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473651;
        bh=enBE6ig5rLsNPHOkyfXqmaui5X7hjG1/VviCzIM8hng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTFoXy4kwuV5RmSCCjjTMXwhW4vddbrVD16fWGLf7+bexfgtfoY9s8g2k1uKN27B+
         fWne5eS+2UTbZ+KO1JaPYkykEfMbjtIl2u5+rlEeaPmeQptMhWFxWRJdvP8IQYgMe4
         kU+w+rBAv+eYcG/YN45rJ4u2+3hIO/QWUS+x9KqteQJVBjPoDl3CU5e//6/4ilaBUR
         yYMbbea4aAlBGAWoNPPny13zOXJnw+ZTRRsek7LGF23ueOohFl/YyDV4t+dWsSNkpR
         AHd+PETulhaRlym3LEY5P+zUWIKj9HB+llM4L2ulG+8YRRBJhtDP0NCcL4Ag54eF/O
         AD4aZKUr/QITw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, unixbhaskar@gmail.com, drv@mailo.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 011/116] media: atomisp-ov2680: Fix ov2680_set_fmt() clobbering the exposure
Date:   Mon, 17 Jan 2022 21:38:22 -0500
Message-Id: <20220118024007.1950576-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4492289c31364d28c2680b43b18883385a5d216c ]

Now that we restore the default or last user set exposure setting on
power_up() there is no need for the registers written by ov2680_set_fmt()
to write to the exposure register.

Not doing so fixes the exposure always being reset to the value from
the res->regs array after a set_fmt().

Link: https://lore.kernel.org/linux-media/20211107171549.267583-11-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/i2c/ov2680.h | 24 ----------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h b/drivers/staging/media/atomisp/i2c/ov2680.h
index 49920245e0647..cafb798a71abe 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.h
+++ b/drivers/staging/media/atomisp/i2c/ov2680.h
@@ -289,8 +289,6 @@ static struct ov2680_reg const ov2680_global_setting[] = {
  */
 static struct ov2680_reg const ov2680_QCIF_30fps[] = {
 	{0x3086, 0x01},
-	{0x3501, 0x24},
-	{0x3502, 0x40},
 	{0x370a, 0x23},
 	{0x3801, 0xa0},
 	{0x3802, 0x00},
@@ -334,8 +332,6 @@ static struct ov2680_reg const ov2680_QCIF_30fps[] = {
  */
 static struct ov2680_reg const ov2680_CIF_30fps[] = {
 	{0x3086, 0x01},
-	{0x3501, 0x24},
-	{0x3502, 0x40},
 	{0x370a, 0x23},
 	{0x3801, 0xa0},
 	{0x3802, 0x00},
@@ -377,8 +373,6 @@ static struct ov2680_reg const ov2680_CIF_30fps[] = {
  */
 static struct ov2680_reg const ov2680_QVGA_30fps[] = {
 	{0x3086, 0x01},
-	{0x3501, 0x24},
-	{0x3502, 0x40},
 	{0x370a, 0x23},
 	{0x3801, 0xa0},
 	{0x3802, 0x00},
@@ -420,8 +414,6 @@ static struct ov2680_reg const ov2680_QVGA_30fps[] = {
  */
 static struct ov2680_reg const ov2680_656x496_30fps[] = {
 	{0x3086, 0x01},
-	{0x3501, 0x24},
-	{0x3502, 0x40},
 	{0x370a, 0x23},
 	{0x3801, 0xa0},
 	{0x3802, 0x00},
@@ -463,8 +455,6 @@ static struct ov2680_reg const ov2680_656x496_30fps[] = {
 */
 static struct ov2680_reg const ov2680_720x592_30fps[] = {
 	{0x3086, 0x01},
-	{0x3501, 0x26},
-	{0x3502, 0x40},
 	{0x370a, 0x23},
 	{0x3801, 0x00}, // X_ADDR_START;
 	{0x3802, 0x00},
@@ -508,8 +498,6 @@ static struct ov2680_reg const ov2680_720x592_30fps[] = {
 */
 static struct ov2680_reg const ov2680_800x600_30fps[] = {
 	{0x3086, 0x01},
-	{0x3501, 0x26},
-	{0x3502, 0x40},
 	{0x370a, 0x23},
 	{0x3801, 0x00},
 	{0x3802, 0x00},
@@ -551,8 +539,6 @@ static struct ov2680_reg const ov2680_800x600_30fps[] = {
  */
 static struct ov2680_reg const ov2680_720p_30fps[] = {
 	{0x3086, 0x00},
-	{0x3501, 0x48},
-	{0x3502, 0xe0},
 	{0x370a, 0x21},
 	{0x3801, 0xa0},
 	{0x3802, 0x00},
@@ -594,8 +580,6 @@ static struct ov2680_reg const ov2680_720p_30fps[] = {
  */
 static struct ov2680_reg const ov2680_1296x976_30fps[] = {
 	{0x3086, 0x00},
-	{0x3501, 0x48},
-	{0x3502, 0xe0},
 	{0x370a, 0x21},
 	{0x3801, 0xa0},
 	{0x3802, 0x00},
@@ -637,8 +621,6 @@ static struct ov2680_reg const ov2680_1296x976_30fps[] = {
 */
 static struct ov2680_reg const ov2680_1456x1096_30fps[] = {
 	{0x3086, 0x00},
-	{0x3501, 0x48},
-	{0x3502, 0xe0},
 	{0x370a, 0x21},
 	{0x3801, 0x90},
 	{0x3802, 0x00},
@@ -682,8 +664,6 @@ static struct ov2680_reg const ov2680_1456x1096_30fps[] = {
 
 static struct ov2680_reg const ov2680_1616x916_30fps[] = {
 	{0x3086, 0x00},
-	{0x3501, 0x48},
-	{0x3502, 0xe0},
 	{0x370a, 0x21},
 	{0x3801, 0x00},
 	{0x3802, 0x00},
@@ -726,8 +706,6 @@ static struct ov2680_reg const ov2680_1616x916_30fps[] = {
 #if 0
 static struct ov2680_reg const ov2680_1616x1082_30fps[] = {
 	{0x3086, 0x00},
-	{0x3501, 0x48},
-	{0x3502, 0xe0},
 	{0x370a, 0x21},
 	{0x3801, 0x00},
 	{0x3802, 0x00},
@@ -769,8 +747,6 @@ static struct ov2680_reg const ov2680_1616x1082_30fps[] = {
  */
 static struct ov2680_reg const ov2680_1616x1216_30fps[] = {
 	{0x3086, 0x00},
-	{0x3501, 0x48},
-	{0x3502, 0xe0},
 	{0x370a, 0x21},
 	{0x3801, 0x00},
 	{0x3802, 0x00},
-- 
2.34.1

