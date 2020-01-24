Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720C4147B48
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbgAXJmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:42:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730576AbgAXJmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:17 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D4A208C4;
        Fri, 24 Jan 2020 09:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858936;
        bh=578cwMkGJ48yKCG4xzXPRkjAQQquHntCAjt+bIka0SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yB8br4+hO+JEUPLdhcVt6XUU9YYYxQ16hoCfDpKwODqQgFQ4/5DlmNi3KbCLFkGNl
         zMUGse7W/E7rbiK9u8lEYT2qdu3aQYYP6RovwXW0ilEn3ZOzQTHu8N1umgmLrP/r9J
         lzWXTK82aXFWD/KWtnq3cb0sBaQ2Zh1j4Lw7NuNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/102] mmc: core: fix wl1251 sdio quirks
Date:   Fri, 24 Jan 2020 10:31:25 +0100
Message-Id: <20200124092819.363720236@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 16568b4a4f0c34bd35cfadac63303c7af7812764 ]

wl1251 and wl1271 have different vendor id and device id.
So we need to handle both with sdio quirks.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/quirks.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index 2d2d9ea8be4f3..3dba15bccce25 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -119,7 +119,14 @@ static const struct mmc_fixup mmc_ext_csd_fixups[] = {
 	END_FIXUP
 };
 
+
 static const struct mmc_fixup sdio_fixup_methods[] = {
+	SDIO_FIXUP(SDIO_VENDOR_ID_TI_WL1251, SDIO_DEVICE_ID_TI_WL1251,
+		   add_quirk, MMC_QUIRK_NONSTD_FUNC_IF),
+
+	SDIO_FIXUP(SDIO_VENDOR_ID_TI_WL1251, SDIO_DEVICE_ID_TI_WL1251,
+		   add_quirk, MMC_QUIRK_DISABLE_CD),
+
 	SDIO_FIXUP(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271,
 		   add_quirk, MMC_QUIRK_NONSTD_FUNC_IF),
 
-- 
2.20.1



