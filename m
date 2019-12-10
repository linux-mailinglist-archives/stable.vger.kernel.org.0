Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6CF1193C4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfLJVKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbfLJVKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72327246A4;
        Tue, 10 Dec 2019 21:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012202;
        bh=jTpiUlKsyB/ccCAr0py+oekD/sHAUrfYfWldZKhQytQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5S6Vkbrfe3foMZUaOFNqxo9GIRqiEZ5yUoqdjT7hADF4BXuQtRzo5xohxd7+PQR9
         K4bALqV3/3ERnXl8+g4jbZuFjGq6YgWMGTih+Vp+8Z606ey0sRV4+ahkmBdqx7lMQy
         +jnCDpqEovf/grBGJ8Osl3hquoA+Njx+tNjBdoC8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 155/350] staging: wilc1000: potential corruption in wilc_parse_join_bss_param()
Date:   Tue, 10 Dec 2019 16:04:20 -0500
Message-Id: <20191210210735.9077-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d59dc92f1bccd5acde793aebdbb4f7121cf3f9af ]

The "rates_len" value needs to be capped so that the memcpy() doesn't
copy beyond the end of the array.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Adham Abozaeid <adham.abozaeid@microchip.com>
Link: https://lore.kernel.org/r/20191017091832.GB31278@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/wilc_hif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_hif.c b/drivers/staging/wilc1000/wilc_hif.c
index d3d9ea284816a..77d0732f451be 100644
--- a/drivers/staging/wilc1000/wilc_hif.c
+++ b/drivers/staging/wilc1000/wilc_hif.c
@@ -473,6 +473,8 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 	rates_ie = cfg80211_find_ie(WLAN_EID_SUPP_RATES, ies->data, ies->len);
 	if (rates_ie) {
 		rates_len = rates_ie[1];
+		if (rates_len > WILC_MAX_RATES_SUPPORTED)
+			rates_len = WILC_MAX_RATES_SUPPORTED;
 		param->supp_rates[0] = rates_len;
 		memcpy(&param->supp_rates[1], rates_ie + 2, rates_len);
 	}
-- 
2.20.1

