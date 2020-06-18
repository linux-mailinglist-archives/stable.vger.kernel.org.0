Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5691FE4A6
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbgFRCTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbgFRBTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50E0221D7E;
        Thu, 18 Jun 2020 01:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443150;
        bh=JS+n9eHJSbbyBwQT+4ZlUCQqCKe0Fm6rnx22FfFJZq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUaN5itMJaj+MG5mIlP7aU/Vs7zm6dXmjB5LVNWVGd/hEKogk/k2VmH/xM3rwhcki
         CqQBKlGwOmx6rethrCK3PLwjYvybJWsjY4sD95JYGchKFA6dAEidIRGdUaB6/1z50p
         KBjs9XcLkdlZj0SUcZseN79bWJQKUHBjVOrFc2+s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oscar Carter <oscar.carter@gmx.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 118/266] staging: wilc1000: Increase the size of wid_list array
Date:   Wed, 17 Jun 2020 21:14:03 -0400
Message-Id: <20200618011631.604574-118-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/staging/wilc1000/wilc_hif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_hif.c b/drivers/staging/wilc1000/wilc_hif.c
index 77d0732f451b..221e3d93db14 100644
--- a/drivers/staging/wilc1000/wilc_hif.c
+++ b/drivers/staging/wilc1000/wilc_hif.c
@@ -12,6 +12,8 @@
 #define WILC_FALSE_FRMWR_CHANNEL		100
 #define WILC_MAX_RATES_SUPPORTED		12
 
+#define WILC_SCAN_WID_LIST_SIZE		6
+
 struct wilc_rcvd_mac_info {
 	u8 status;
 };
@@ -233,7 +235,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
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

