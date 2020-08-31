Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916D6257C4A
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgHaP3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgHaP3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA7420767;
        Mon, 31 Aug 2020 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887777;
        bh=YMyeZdu9AK2XDZlChIpD6tD+lXjuHM/nRNxJfMP4bXk=;
        h=From:To:Cc:Subject:Date:From;
        b=vCZnMO8HXIRovZkJewNRE+4TpmdeD6vq1a1GUQuI6aMPEQufBwfs5v03GJm3NmBJY
         plOy3B9d8C8ZFFVP4Zc9RZqQZnvFav+EIIYRy7btgop1aN2IqYeBYeWlWFWFcNAELC
         eJ7cUnerNS73fWiwgQZKg9Ys4gc8t8CzSWNOcH2s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Peltier <grantpeltier93@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 01/42] hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_1 telemetry for RAA228228
Date:   Mon, 31 Aug 2020 11:28:53 -0400
Message-Id: <20200831152934.1023912-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grant Peltier <grantpeltier93@gmail.com>

[ Upstream commit 51fb91ed5a6fa855a74731610cd5435d83d6e17f ]

Per the RAA228228 datasheet, READ_TEMPERATURE_1 is not a supported PMBus
command.

Signed-off-by: Grant Peltier <grantpeltier93@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/isl68137.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/isl68137.c b/drivers/hwmon/pmbus/isl68137.c
index 0c622711ef7e0..58aa95a3c010c 100644
--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -67,6 +67,7 @@ enum variants {
 	raa_dmpvr1_2rail,
 	raa_dmpvr2_1rail,
 	raa_dmpvr2_2rail,
+	raa_dmpvr2_2rail_nontc,
 	raa_dmpvr2_3rail,
 	raa_dmpvr2_hv,
 };
@@ -241,6 +242,10 @@ static int isl68137_probe(struct i2c_client *client,
 		info->pages = 1;
 		info->read_word_data = raa_dmpvr2_read_word_data;
 		break;
+	case raa_dmpvr2_2rail_nontc:
+		info->func[0] &= ~PMBUS_HAVE_TEMP;
+		info->func[1] &= ~PMBUS_HAVE_TEMP;
+		fallthrough;
 	case raa_dmpvr2_2rail:
 		info->pages = 2;
 		info->read_word_data = raa_dmpvr2_read_word_data;
@@ -304,7 +309,7 @@ static const struct i2c_device_id raa_dmpvr_id[] = {
 	{"raa228000", raa_dmpvr2_hv},
 	{"raa228004", raa_dmpvr2_hv},
 	{"raa228006", raa_dmpvr2_hv},
-	{"raa228228", raa_dmpvr2_2rail},
+	{"raa228228", raa_dmpvr2_2rail_nontc},
 	{"raa229001", raa_dmpvr2_2rail},
 	{"raa229004", raa_dmpvr2_2rail},
 	{}
-- 
2.25.1

