Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5D7147604
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbgAXBRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgAXBRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DFA21D7D;
        Fri, 24 Jan 2020 01:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828655;
        bh=U9J6SAGCr4N06fDBextBl9dpxjurIa6c2Yu7jpChH4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ax1GVpEny5Q4RDZac2Mn7FjdsPhdclS7mwlnajO6xt9+B+zIpe3UUKsO0IhGNxmV2
         dl2t3SFpGdlPuFyNN7fdC1DAmC2bq3ZTimaULbXFE8eCFmDjlriUugGjshrZ17qDUE
         ymx88mianXO78hDZ+SCi7LsxwdpUsFHzieUt6bxg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/33] mmc: sdio: fix wl1251 vendor id
Date:   Thu, 23 Jan 2020 20:16:58 -0500
Message-Id: <20200124011708.18232-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit e5db673e7fe2f971ec82039a28dc0811c2100e87 ]

v4.11-rc1 did introduce a patch series that rearranged the
sdio quirks into a header file. Unfortunately this did forget
to handle SDIO_VENDOR_ID_TI differently between wl1251 and
wl1271 with the result that although the wl1251 was found on
the sdio bus, the firmware did not load any more and there was
no interface registration.

This patch defines separate constants to be used by sdio quirks
and drivers.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmc/sdio_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index d1a5d5df02f57..08b25c02b5a11 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -71,6 +71,8 @@
 
 #define SDIO_VENDOR_ID_TI			0x0097
 #define SDIO_DEVICE_ID_TI_WL1271		0x4076
+#define SDIO_VENDOR_ID_TI_WL1251		0x104c
+#define SDIO_DEVICE_ID_TI_WL1251		0x9066
 
 #define SDIO_VENDOR_ID_STE			0x0020
 #define SDIO_DEVICE_ID_STE_CW1200		0x2280
-- 
2.20.1

