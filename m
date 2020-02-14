Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED1415F487
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392410AbgBNSVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:21:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbgBNPtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC64A2086A;
        Fri, 14 Feb 2020 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695382;
        bh=GM6SWoSqzW6VjK+HK2Fz5Drs/r7qVg46S6Jp0irKb0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJWSuM+3BulvVOc23Y3Xl9xyMNE3aIapePFQnrTFLwTN4h9Y9iJryQCWAGLnYTFDr
         jYF5sQbIJlp1MbUnVZ//7E/ryOksWIMCXafyNZtv500h5gTPgiFwn8ieRac4O4tSmA
         Z4U+m91TdkTu29TP99WbTUDgErxPGc/Yqf6UlchE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 037/542] drm/mipi_dbi: Fix off-by-one bugs in mipi_dbi_blank()
Date:   Fri, 14 Feb 2020 10:40:29 -0500
Message-Id: <20200214154854.6746-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2ce18249af5a28031b3f909cfafccc88ea966c9d ]

When configuring the frame memory window, the last column and row
numbers are written to the column resp. page address registers.  These
numbers are thus one less than the actual window width resp. height.

While this is handled correctly in mipi_dbi_fb_dirty() since commit
03ceb1c8dfd1e293 ("drm/tinydrm: Fix setting of the column/page end
addresses."), it is not in mipi_dbi_blank().  The latter still forgets
to subtract one when calculating the most significant bytes of the
column and row numbers, thus programming wrong values when the display
width or height is a multiple of 256.

Fixes: 02dd95fe31693626 ("drm/tinydrm: Add MIPI DBI support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191230130604.31006-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
index e34058c721bec..16bff1be4b8ac 100644
--- a/drivers/gpu/drm/drm_mipi_dbi.c
+++ b/drivers/gpu/drm/drm_mipi_dbi.c
@@ -367,9 +367,9 @@ static void mipi_dbi_blank(struct mipi_dbi_dev *dbidev)
 	memset(dbidev->tx_buf, 0, len);
 
 	mipi_dbi_command(dbi, MIPI_DCS_SET_COLUMN_ADDRESS, 0, 0,
-			 (width >> 8) & 0xFF, (width - 1) & 0xFF);
+			 ((width - 1) >> 8) & 0xFF, (width - 1) & 0xFF);
 	mipi_dbi_command(dbi, MIPI_DCS_SET_PAGE_ADDRESS, 0, 0,
-			 (height >> 8) & 0xFF, (height - 1) & 0xFF);
+			 ((height - 1) >> 8) & 0xFF, (height - 1) & 0xFF);
 	mipi_dbi_command_buf(dbi, MIPI_DCS_WRITE_MEMORY_START,
 			     (u8 *)dbidev->tx_buf, len);
 
-- 
2.20.1

