Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C413EB5E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394197AbgAPRqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394179AbgAPRqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:46:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F5C0246D0;
        Thu, 16 Jan 2020 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196762;
        bh=ChIPeAG1dGINkg+Fp76gMqPv0W47WaRVmtClRrlqMlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3u/z+mdJGwhBBIGBj62TNvkBh+0kWRitc0OQzNkn8r4PpCfudTJdDMrAkwJtuJyL
         fQzkGUqe6Tvda4IRGPVZG/87W3prUwivDd4xMvdh+f9vktciWhu5Mf8t2sqIWZuJMR
         /IV7fUlpFszKdRz6l9DNsSqVMM+Z4N+Ylp3to2g0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 136/174] hwmon: (shtc1) fix shtc1 and shtw1 id mask
Date:   Thu, 16 Jan 2020 12:42:13 -0500
Message-Id: <20200116174251.24326-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Robertson <dan@dlrobertson.com>

[ Upstream commit fdc7d8e829ec755c5cfb2f5a8d8c0cdfb664f895 ]

Fix an error in the bitmaskfor the shtc1 and shtw1 bitmask used to
retrieve the chip ID from the ID register. See section 5.7 of the shtw1
or shtc1 datasheet for details.

Fixes: 1a539d372edd9832444e7a3daa710c444c014dc9 ("hwmon: add support for Sensirion SHTC1 sensor")
Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Link: https://lore.kernel.org/r/20190905014554.21658-3-dan@dlrobertson.com
[groeck: Reordered to be first in series and adjusted accordingly]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/shtc1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
index decd7df995ab..2a18539591ea 100644
--- a/drivers/hwmon/shtc1.c
+++ b/drivers/hwmon/shtc1.c
@@ -38,7 +38,7 @@ static const unsigned char shtc1_cmd_read_id_reg[]	       = { 0xef, 0xc8 };
 
 /* constants for reading the ID register */
 #define SHTC1_ID	  0x07
-#define SHTC1_ID_REG_MASK 0x1f
+#define SHTC1_ID_REG_MASK 0x3f
 
 /* delays for non-blocking i2c commands, both in us */
 #define SHTC1_NONBLOCKING_WAIT_TIME_HPM  14400
-- 
2.20.1

