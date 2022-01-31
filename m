Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA6F4A42FA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376686AbiAaLPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:15:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44952 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377003AbiAaLNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:13:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5DEC611D9;
        Mon, 31 Jan 2022 11:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14ECC340EF;
        Mon, 31 Jan 2022 11:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627611;
        bh=42keL3IE7xfYYTuDFGFSXIoBuVeHfX3O1QQtmA7j5bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfJvpifGHR2vFnwCIxNhp7bE4eqV2nqzC+Dn3BvuCSXzckn9EFi0TvKvLC/g2rT8D
         c7EaEWk60NGB54Hzm8OOTao4WK6Uoa1AqjMS9Q0yDo4DmFHzqf+7YAGRqcfUKhPPcY
         0uD2MGgxcBLtZommN8hPGS3iNqqAValajBP+Cu+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Lehan <krellan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/171] hwmon: (lm90) Mark alert as broken for MAX6654
Date:   Mon, 31 Jan 2022 11:56:38 +0100
Message-Id: <20220131105234.506755641@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a53fff96f35763d132a36c620b183fdf11022d7a ]

Experiments with MAX6654 show that its alert function is broken,
similar to other chips supported by the lm90 driver. Mark it accordingly.

Fixes: 229d495d8189 ("hwmon: (lm90) Add max6654 support to lm90 driver")
Cc: Josh Lehan <krellan@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index e4ecf3440d7cf..280ae5f58187b 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -400,6 +400,7 @@ static const struct lm90_params lm90_params[] = {
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6654] = {
+		.flags = LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 7,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
-- 
2.34.1



