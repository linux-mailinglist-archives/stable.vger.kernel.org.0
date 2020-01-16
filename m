Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEDE13F650
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391697AbgAPTC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387809AbgAPRFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE131207FF;
        Thu, 16 Jan 2020 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194329;
        bh=JJoNUAn5XTcRHAbd/GoL60h9POSWMI/lFT0ZqauAsxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOtrOjyYhMCsayaCVl0LO8Ma6XUWggxBsR/isGZgtQ6KTcDHieZjJLWYZFryvRXR4
         KhBVTx6KQqM4bxz1jYo6zDD45586Ekhdg4en2tRiOa5LLIkSsqcJJAw5Folt8moZNq
         gjQllMedGH07lYdhHXarcPaZz9dsa+CKtNDEXeVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 277/671] rtc: Fix timestamp value for RTC_TIMESTAMP_BEGIN_1900
Date:   Thu, 16 Jan 2020 11:58:35 -0500
Message-Id: <20200116170509.12787-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d3062d1d7415cb5a37777220357aca51a491c3d7 ]

Printing "mktime64(1900, 1, 1, 0, 0, 0)" gives -2208988800.

Fixes: 83bbc5ac63326433 ("rtc: Add useful timestamp definitions")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6aedc30003e7..5a34f59941fb 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -163,7 +163,7 @@ struct rtc_device {
 #define to_rtc_device(d) container_of(d, struct rtc_device, dev)
 
 /* useful timestamps */
-#define RTC_TIMESTAMP_BEGIN_1900	-2208989361LL /* 1900-01-01 00:00:00 */
+#define RTC_TIMESTAMP_BEGIN_1900	-2208988800LL /* 1900-01-01 00:00:00 */
 #define RTC_TIMESTAMP_BEGIN_2000	946684800LL /* 2000-01-01 00:00:00 */
 #define RTC_TIMESTAMP_END_2099		4102444799LL /* 2099-12-31 23:59:59 */
 
-- 
2.20.1

