Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA19E22EF78
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgG0OQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730918AbgG0OQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5A02070A;
        Mon, 27 Jul 2020 14:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859401;
        bh=KHiEmeSDHEk36Ap081u5lxBnesPSBOC4MwK1QNOPB98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e91EX2abEWlTZJbQpkegbBxyavBDnWEQSGvUbNNn8coIsor2bXeRyQGF31VQn0xvb
         UvjDH0Hff9NrdvtLFIr02qlrOjAKjqylRcg17CJQSvAcOQ492pjxcGxn+oC8IZxdIJ
         46GIwjfiBFW4hOgoddd7lCz7ZBjuhIoC+ZoINNwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Dietrich <roots@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/138] hwmon: (nct6775) Accept PECI Calibration as temperature source for NCT6798D
Date:   Mon, 27 Jul 2020 16:04:48 +0200
Message-Id: <20200727134930.028179403@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8a03746c8baf82e1616f05a1a716d34378dcf780 ]

Stefan Dietrich reports invalid temperature source messages on Asus Formula
XII Z490.

nct6775 nct6775.656: Invalid temperature source 28 at index 0,
		source register 0x100, temp register 0x73

Debugging suggests that temperature source 28 reports the CPU temperature.
Let's assume that temperature sources 28 and 29 reflect "PECI Agent {0,1}
Calibration", similar to other chips of the series.

Reported-by: Stefan Dietrich <roots@gmx.de>
Cc: Stefan Dietrich <roots@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index 7efa6bfef0609..ba9b96973e808 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -786,13 +786,13 @@ static const char *const nct6798_temp_label[] = {
 	"Agent1 Dimm1",
 	"BYTE_TEMP0",
 	"BYTE_TEMP1",
-	"",
-	"",
+	"PECI Agent 0 Calibration",	/* undocumented */
+	"PECI Agent 1 Calibration",	/* undocumented */
 	"",
 	"Virtual_TEMP"
 };
 
-#define NCT6798_TEMP_MASK	0x8fff0ffe
+#define NCT6798_TEMP_MASK	0xbfff0ffe
 #define NCT6798_VIRT_TEMP_MASK	0x80000c00
 
 /* NCT6102D/NCT6106D specific data */
-- 
2.25.1



