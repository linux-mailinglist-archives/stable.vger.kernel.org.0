Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1843E49A392
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365543AbiAXXvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450302AbiAXVyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:54:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73D7C0C0912;
        Mon, 24 Jan 2022 12:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93CA6B8121C;
        Mon, 24 Jan 2022 20:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB15FC340E5;
        Mon, 24 Jan 2022 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056504;
        bh=oXLBzOz/hkAg5gBd5Fy/0nL79/vChLwPGP35T3oMc8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEFr4ZlUxmJf+CcDL4DXnJtLaXEEuiRUTsAcP+9T05AEJotbpLvG5A0rnokJV6+0/
         iaVAyLFp4OMICbU1fJ03NBWz/k9n5G0suHm5uZipAmexqc18McUNDk/6jv+PUV9PxQ
         JuBKmB9fd25J4VlsTV7KjJfqwd8tG1saqy5lzqjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 474/846] media: atomisp-ov2680: Fix ov2680_set_fmt() clobbering the exposure
Date:   Mon, 24 Jan 2022 19:39:51 +0100
Message-Id: <20220124184117.365624390@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 874115f35fcad..798b28e134b64 100644
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



