Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8664A414C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358561AbiAaLDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358969AbiAaLCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2BCC06135C;
        Mon, 31 Jan 2022 03:00:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3FDB82A67;
        Mon, 31 Jan 2022 11:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB79C340EF;
        Mon, 31 Jan 2022 11:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626827;
        bh=pEbtwk1Tu+AIA9m5CSRw9WEv78RmSuPWfYDqnGxqOKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LB4O2HILfFH2tzPXcRk2HeMhXzJUeN18Qrp2B2FULy9Ll6CR+SIUvN6KHjJIEC5Zv
         imB1alJKorMIIpxP/DajX/G3AyFs+biFUxb+5OEbn5WJz9sbGbJC4NxLLOBxry9cY2
         5JFgGvYCkkzdvVu2bGHlXBlQq3H4WXgdwTbtim3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Lehan <krellan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/64] hwmon: (lm90) Mark alert as broken for MAX6654
Date:   Mon, 31 Jan 2022 11:56:38 +0100
Message-Id: <20220131105217.468698771@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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
index 0e3304d1c3f28..28b408728282d 100644
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



