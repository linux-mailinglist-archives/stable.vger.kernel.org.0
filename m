Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD0D205D26
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388726AbgFWUJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388153AbgFWUJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628DD206C3;
        Tue, 23 Jun 2020 20:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942970;
        bh=BW3fkcBMyWUVG8IZl9uDIzwc+hIIUmKIYbFBCWF5tLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qb2G4drSwbSLW9UlxvZOTgZigNt3UIMdIlEc7zh+zi436OqqyID/UO5l83kBxPifG
         Yx1u1q/E/Ng8BfL3SNpsAn1IhaACyguOQ/GfqYH2A1H57eP772Vian18/FxswqV+bx
         Ugi3vXkJ8vs/Kb+TdsYWLOr3JE9/6fiv+DKVJG98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Singh <ajay.kathat@microchip.com>,
        Oscar Carter <oscar.carter@gmx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 167/477] staging: wilc1000: Increase the size of wid_list array
Date:   Tue, 23 Jun 2020 21:52:44 +0200
Message-Id: <20200623195415.480902963@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Carter <oscar.carter@gmx.com>

[ Upstream commit a4338ed2e1cf724563956ec5f91deeaabfedbe23 ]

Increase by one the size of wid_list array as index variable can reach a
value of 5. If this happens, an out-of-bounds access is performed.

Also, use a #define instead of a hard-coded literal for the new array
size.

Addresses-Coverity-ID: 1451981 ("Out-of-bounds access")
Fixes: f5a3cb90b802d ("staging: wilc1000: add passive scan support")
Acked-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
Link: https://lore.kernel.org/r/20200504150911.4470-1-oscar.carter@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/hif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/hif.c b/drivers/staging/wilc1000/hif.c
index 6c7de2f8d3f26..d025a30930157 100644
--- a/drivers/staging/wilc1000/hif.c
+++ b/drivers/staging/wilc1000/hif.c
@@ -11,6 +11,8 @@
 
 #define WILC_FALSE_FRMWR_CHANNEL		100
 
+#define WILC_SCAN_WID_LIST_SIZE		6
+
 struct wilc_rcvd_mac_info {
 	u8 status;
 };
@@ -151,7 +153,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      void *user_arg, struct cfg80211_scan_request *request)
 {
 	int result = 0;
-	struct wid wid_list[5];
+	struct wid wid_list[WILC_SCAN_WID_LIST_SIZE];
 	u32 index = 0;
 	u32 i, scan_timeout;
 	u8 *buffer;
-- 
2.25.1



