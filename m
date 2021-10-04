Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AA0420DC0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhJDNSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235750AbhJDNQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03FAD61BA8;
        Mon,  4 Oct 2021 13:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352791;
        bh=I2etFlXvpAhsBcT+O1eRDwIbnvp39z8/zOR6c1KJGsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uw5ctv9u3LKClOHDONLw3+Ug/V0JGoju7S4nsLD8yFZaaQzcqiqgyDVfHMdHq2o96
         o24BYU+cSe4vkVO/YzfzjN99Ja3ubK0CSjDjZ1prRfrMODxEEUEDcEj53CUNEwcZBh
         /bLLBgUFSnFy4LpJeaNr4QGkYjAEGLHHD0eQWEQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/56] hwmon: (tmp421) report /PVLD condition as fault
Date:   Mon,  4 Oct 2021 14:52:40 +0200
Message-Id: <20211004125030.641485449@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Fertser <fercerpav@gmail.com>

[ Upstream commit 540effa7f283d25bcc13c0940d808002fee340b8 ]

For both local and remote sensors all the supported ICs can report an
"undervoltage lockout" condition which means the conversion wasn't
properly performed due to insufficient power supply voltage and so the
measurement results can't be trusted.

Fixes: 9410700b881f ("hwmon: Add driver for Texas Instruments TMP421/422/423 sensor chips")
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Link: https://lore.kernel.org/r/20210924093011.26083-2-fercerpav@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp421.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index a94e35cff3e5..e245ae272f7d 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -160,10 +160,10 @@ static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 		return 0;
 	case hwmon_temp_fault:
 		/*
-		 * The OPEN bit signals a fault. This is bit 0 of the temperature
-		 * register (low byte).
+		 * Any of OPEN or /PVLD bits indicate a hardware mulfunction
+		 * and the conversion result may be incorrect
 		 */
-		*val = tmp421->temp[channel] & 0x01;
+		*val = !!(tmp421->temp[channel] & 0x03);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -176,9 +176,6 @@ static umode_t tmp421_is_visible(const void *data, enum hwmon_sensor_types type,
 {
 	switch (attr) {
 	case hwmon_temp_fault:
-		if (channel == 0)
-			return 0;
-		return 0444;
 	case hwmon_temp_input:
 		return 0444;
 	default:
-- 
2.33.0



