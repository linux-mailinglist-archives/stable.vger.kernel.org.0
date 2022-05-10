Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E882B521FFC
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346664AbiEJPxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347030AbiEJPvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2A42457A8;
        Tue, 10 May 2022 08:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869CC615A5;
        Tue, 10 May 2022 15:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C365C385A6;
        Tue, 10 May 2022 15:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197600;
        bh=k7NdOnPBJCcgtgOHqgdMJ6TXBvkuxMVH2PFiZnYqYvk=;
        h=From:To:Cc:Subject:Date:From;
        b=A39jedJRCVvf0WCTlpOKkKm6x/DUe/y51LN4xjZrZ8KLR9Tt1mPWpfmvPOiZHOJsq
         bhNmp0cN6cLrwMc21WLncAi+OurS/qJucQy1L/HRgc/Uf01g9YlsPsO39Qm/sTvjAE
         MCNAHIsQZXgKXBKSlKl0DUWxtifOsfb3Gf4h4HIVYHJhlEy8h/U5FCsLQWRhQ9n03L
         TewAGz8Dl4oOagFxbIumRofr391ijzkJq5qajeB5iBjVH70TYwrnCDt5yt2y4qz9PY
         FRFgKtzPUHYvlLuHQxMOh/GEmN9qx3hB+KXjraKUqehajCgTFBji2L6Du71sxjw7PW
         3dRMA14qnegcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>,
        Ji-Ze Hong <hpeter+linux_kernel@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/5] hwmon: (f71882fg) Fix negative temperature
Date:   Tue, 10 May 2022 11:46:33 -0400
Message-Id: <20220510154637.154283-1-sashal@kernel.org>
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
index ca54ce5c8e10..4010b61743f5 100644
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

