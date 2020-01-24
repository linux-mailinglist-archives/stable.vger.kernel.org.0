Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105DF148452
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390297AbgAXLPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390289AbgAXLPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF5120708;
        Fri, 24 Jan 2020 11:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864532;
        bh=cKzUfZ395xASYGLH4lTkD8MFhnYdN4Pw5e4VHBn88g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJ8lKZWFOR62Fk79VmbDZelJDrXrhHnhVmI4YivaODLtKO2axQuvh3+QdN0rkTR/0
         eto3VWk0v5BDpcKBPXS/dRbhA7ehsv4hZ8z1Ty9ffWCix+mnppYsFdAHEjhqlyB6tD
         qWJG8oj/RLjfp5QCKE8Hy+nyK4YbsckNiywtMJrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 292/639] rtc: Fix timestamp value for RTC_TIMESTAMP_BEGIN_1900
Date:   Fri, 24 Jan 2020 10:27:42 +0100
Message-Id: <20200124093123.464540019@linuxfoundation.org>
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
index 6aedc30003e73..5a34f59941fb7 100644
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



