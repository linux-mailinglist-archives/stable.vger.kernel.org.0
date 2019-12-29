Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FC712C69C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfL2Rst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731517AbfL2Rss (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D562207FD;
        Sun, 29 Dec 2019 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641727;
        bh=Bc+4ThAwjEDmbN9IZHF968Zw5Q9/PkRTJXe4suKGGWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OasFJQYkAJqvWOQPm9HghrCucMwnLDsAGR84qaLYR6MsCP337liJwEDhl/EbLZ3RU
         FeYjqC1N2/yIuWtmItmGv4hHNfRSAxtnRWdRYphJgBDc1tX2NL3UMW8Y8iXZE7ww7s
         4Y5e5wpeeElU+2f8IMfh6tzdh7rM/U2S8dDVNeqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 184/434] staging: wilc1000: potential corruption in wilc_parse_join_bss_param()
Date:   Sun, 29 Dec 2019 18:23:57 +0100
Message-Id: <20191229172714.039031122@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d3d9ea284816..77d0732f451b 100644
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



