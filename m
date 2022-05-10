Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189EF521FB6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346350AbiEJPwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347184AbiEJPwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:52:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D552289BFF;
        Tue, 10 May 2022 08:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C879B81DF7;
        Tue, 10 May 2022 15:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338AFC385A6;
        Tue, 10 May 2022 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197628;
        bh=Xb2iH1RD9rLYp/HcvNZ8NPrqSJ1SAA5g+w9cI06BPY0=;
        h=From:To:Cc:Subject:Date:From;
        b=ukOl6X+c/SsN0hsstWhZKeDN8MHZ6nYlKiZzAvAsr1uNJO/cNJNX7o/zo5xSZVmcS
         C6M64OO4Zgdjd2FC+YQ0p3Dg+n5YzqBrgd4kStmOcpquWF1Y51co4mP0asvQ272HeI
         rOMUFzp13Jyrssyk96W5aLHX6kWaSVztN/V3Mni0TkOi+Y3nF+ywia9SVFrFu7BGPZ
         dqrOav3XRQirXc4TYbfjDB7N55hAv+8rIDESv5CpVGmm435t6UeGJIhIvuqnJXMhzU
         bDfim4ym4MSc9zCcf5dxxgCvG/VA3TSLP/pzSJ5NVU/W64aBBR7oua2OjvNMYj3Phe
         Y9NZu+/qSi+xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>,
        Ji-Ze Hong <hpeter+linux_kernel@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/4] hwmon: (f71882fg) Fix negative temperature
Date:   Tue, 10 May 2022 11:47:00 -0400
Message-Id: <20220510154704.154362-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>

[ Upstream commit 4aaaaf0f279836f06d3b9d0ffeec7a1e1a04ceef ]

All temperature of Fintek superio hwmonitor that using 1-byte reg will use
2's complement.

In show_temp()
	temp = data->temp[nr] * 1000;

When data->temp[nr] read as 255, it indicate -1C, but this code will report
255C to userspace. It'll be ok when change to:
	temp = ((s8)data->temp[nr]) * 1000;

Signed-off-by: Ji-Ze Hong (Peter Hong) <hpeter+linux_kernel@gmail.com>
Link: https://lore.kernel.org/r/20220418090706.6339-1-hpeter+linux_kernel@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/f71882fg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index cb28e4b4fb10..b87ca56fb774 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -1590,8 +1590,9 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *devattr,
 		temp *= 125;
 		if (sign)
 			temp -= 128000;
-	} else
-		temp = data->temp[nr] * 1000;
+	} else {
+		temp = ((s8)data->temp[nr]) * 1000;
+	}
 
 	return sprintf(buf, "%d\n", temp);
 }
-- 
2.35.1

