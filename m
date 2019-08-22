Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE899E43
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389815AbfHVRt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389710AbfHVRWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:14 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B60721743;
        Thu, 22 Aug 2019 17:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494534;
        bh=tkEmI7RqUTaTZ6SsqJB23aw8Lx/Dj950ZxCE59nDzs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlJPWqs4N11ADUTCaMiW9+Rn6YjeGXNxzmNntS9bDCNnMPXEn2O9QfxTgGZaGdDMq
         AOwZB3gAOqYTCptuf0dCQXOiJqLmRcLdLGSWf32xBe1LTjzNBOZNtC4dvdZAbrnUl/
         5HBBCKZZhz6Lo92a9Oq8POGuwm5mOXpwQVO50ei0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjoern Gerhart <gerhart@posteo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/78] hwmon: (nct6775) Fix register address and added missed tolerance for nct6106
Date:   Thu, 22 Aug 2019 10:18:16 -0700
Message-Id: <20190822171832.398069261@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f3d43e2e45fd9d44ba52d20debd12cd4ee9c89bf ]

Fixed address of third NCT6106_REG_WEIGHT_DUTY_STEP, and
added missed NCT6106_REG_TOLERANCE_H.

Fixes: 6c009501ff200 ("hwmon: (nct6775) Add support for NCT6102D/6106D")
Signed-off-by: Bjoern Gerhart <gerhart@posteo.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index d3c6115f16b90..db38dff3f9867 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -696,7 +696,7 @@ static const u16 NCT6106_REG_TARGET[] = { 0x111, 0x121, 0x131 };
 static const u16 NCT6106_REG_WEIGHT_TEMP_SEL[] = { 0x168, 0x178, 0x188 };
 static const u16 NCT6106_REG_WEIGHT_TEMP_STEP[] = { 0x169, 0x179, 0x189 };
 static const u16 NCT6106_REG_WEIGHT_TEMP_STEP_TOL[] = { 0x16a, 0x17a, 0x18a };
-static const u16 NCT6106_REG_WEIGHT_DUTY_STEP[] = { 0x16b, 0x17b, 0x17c };
+static const u16 NCT6106_REG_WEIGHT_DUTY_STEP[] = { 0x16b, 0x17b, 0x18b };
 static const u16 NCT6106_REG_WEIGHT_TEMP_BASE[] = { 0x16c, 0x17c, 0x18c };
 static const u16 NCT6106_REG_WEIGHT_DUTY_BASE[] = { 0x16d, 0x17d, 0x18d };
 
@@ -3478,6 +3478,7 @@ static int nct6775_probe(struct platform_device *pdev)
 		data->REG_FAN_TIME[0] = NCT6106_REG_FAN_STOP_TIME;
 		data->REG_FAN_TIME[1] = NCT6106_REG_FAN_STEP_UP_TIME;
 		data->REG_FAN_TIME[2] = NCT6106_REG_FAN_STEP_DOWN_TIME;
+		data->REG_TOLERANCE_H = NCT6106_REG_TOLERANCE_H;
 		data->REG_PWM[0] = NCT6106_REG_PWM;
 		data->REG_PWM[1] = NCT6106_REG_FAN_START_OUTPUT;
 		data->REG_PWM[2] = NCT6106_REG_FAN_STOP_OUTPUT;
-- 
2.20.1



