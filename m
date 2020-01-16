Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FDE13E878
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392724AbgAPRa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404637AbgAPRaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:30:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55B60246A9;
        Thu, 16 Jan 2020 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195855;
        bh=sVAcU0U1Afdh1SDicf+4JPZiogWd5Q+c2pf+MC5Fx5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+gSBUJ86q8OS1Z0GRrqcj+4gbIpoDDGVAlexJX3OC4CxBjy4ckJ+kW2mFLdjpLrt
         36nYAaOVJqttLiTvHFxsrH5GN25TkCrRsxU3n8lAonGud/JweSf1aeSKfl5nJly8vx
         bxc6ZHp/ixWjSPV37SQpBoQyE0hNHwDI/DzRbH3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 354/371] mmc: core: fix wl1251 sdio quirks
Date:   Thu, 16 Jan 2020 12:23:46 -0500
Message-Id: <20200116172403.18149-297-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

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
index 5153577754f0..09897abb79ed 100644
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

