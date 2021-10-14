Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D82C42DD82
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhJNPIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233678AbhJNPGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:06:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866A161208;
        Thu, 14 Oct 2021 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223706;
        bh=LjyaNBioHQI0wflgWcjTsgXGj6lchXDXS+9YPalogTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAQARofqbpJ1RAN0dTnOrUATsJBo12Uim1A+1qT6MNsXOnlSBZWFudFtLo+4KUGyX
         JUGAGjrj+sXgKmlcgpLJu4qpUwvUrked0EWrIK1AQ/5utEiSBOBOUQtwAyRj3Cih4U
         5EmJH/Vw3SpAvfCLgGvkt+/EJYCxl7MzZfjf/OXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Wyman <bjwyman@gmail.com>,
        Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 30/30] hwmon: (pmbus/ibm-cffps) max_power_out swap changes
Date:   Thu, 14 Oct 2021 16:54:35 +0200
Message-Id: <20211014145210.508839849@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brandon Wyman <bjwyman@gmail.com>

[ Upstream commit f067d5585cda2de1e47dde914a8a4f151659e0ad ]

The bytes for max_power_out from the ibm-cffps devices differ in byte
order for some power supplies.

The Witherspoon power supply returns the bytes in MSB/LSB order.

The Rainier power supply returns the bytes in LSB/MSB order.

The Witherspoon power supply uses version cffps1. The Rainier power
supply should use version cffps2. If version is cffps1, swap the bytes
before output to max_power_out.

Tested:
    Witherspoon before: 3148. Witherspoon after: 3148.
    Rainier before: 53255. Rainier after: 2000.

Signed-off-by: Brandon Wyman <bjwyman@gmail.com>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20210928205051.1222815-1-bjwyman@gmail.com
[groeck: Replaced yoda programming]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/ibm-cffps.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pmbus/ibm-cffps.c b/drivers/hwmon/pmbus/ibm-cffps.c
index df712ce4b164..53f7d1418bc9 100644
--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -171,8 +171,14 @@ static ssize_t ibm_cffps_debugfs_read(struct file *file, char __user *buf,
 		cmd = CFFPS_SN_CMD;
 		break;
 	case CFFPS_DEBUGFS_MAX_POWER_OUT:
-		rc = i2c_smbus_read_word_swapped(psu->client,
-						 CFFPS_MAX_POWER_OUT_CMD);
+		if (psu->version == cffps1) {
+			rc = i2c_smbus_read_word_swapped(psu->client,
+					CFFPS_MAX_POWER_OUT_CMD);
+		} else {
+			rc = i2c_smbus_read_word_data(psu->client,
+					CFFPS_MAX_POWER_OUT_CMD);
+		}
+
 		if (rc < 0)
 			return rc;
 
-- 
2.33.0



