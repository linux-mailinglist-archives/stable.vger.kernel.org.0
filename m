Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A653148368
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404583AbgAXLfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:35:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387523AbgAXLfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:35:52 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8112206F0;
        Fri, 24 Jan 2020 11:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865751;
        bh=PYky6g+LD+ZorvkzmDMOwOA9+Te/d4CjtLHXdj/Msv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVqjhPfnyk4F1eib4FaI3eZRfHiRv3ky/xfIQpvCmTadp/YUCv8mCF9cXYVzGA3uI
         wP860xOPHT3RrMjQ3Q6qNvT9GvgLgvH1Zn5CKOaPuHJ4kQQlYPS7aE/cIaE3VFSVHK
         xdl0TVjwJfdFuspdx5fAakggy/VNheN5jntUGogQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 627/639] mmc: sdio: fix wl1251 vendor id
Date:   Fri, 24 Jan 2020 10:33:17 +0100
Message-Id: <20200124093208.143092778@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

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
index 4224902a8e22a..358d6be357eda 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -68,6 +68,8 @@
 
 #define SDIO_VENDOR_ID_TI			0x0097
 #define SDIO_DEVICE_ID_TI_WL1271		0x4076
+#define SDIO_VENDOR_ID_TI_WL1251		0x104c
+#define SDIO_DEVICE_ID_TI_WL1251		0x9066
 
 #define SDIO_VENDOR_ID_STE			0x0020
 #define SDIO_DEVICE_ID_STE_CW1200		0x2280
-- 
2.20.1



