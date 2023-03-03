Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786A86AA456
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjCCWaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjCCW37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:29:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED06BDEB;
        Fri,  3 Mar 2023 14:24:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07C4DCE229F;
        Fri,  3 Mar 2023 21:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCDEC433A0;
        Fri,  3 Mar 2023 21:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879968;
        bh=WWKbL0XAaTcC2WdR556Ciru5qUvwI0Tp6k1Vu5sihl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPERsjXbY5CTzeLN16bSAtU63Ds57w5Vm+HBVMTpxvWtCpyqvHdnsPZiDM8kQkF0a
         FSt5KwuCzcYvHmSAlinx0clv09qVZr90DjJ+Fvos3MynkRHX60IiJLx/vKyFKtwGz3
         e7uV4yz59mjfUHIhFZqizwUct88CMJcWIv2m4jeOIxZx7H+0tURJxsjYYWJI0rNJp7
         PrkITgdNwk6w45MBwRY/DIubaXtykYIbNe7LFBhfve2t1PItKNabK4UZAldRup9+l7
         d8tTeoktVomOU84N1SyA8+IGGd+HhxEmohW6tpXOMB3z+BK/NtvB0DK7JnmUo0fxgn
         YGeGG3TuO/9Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/50] iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()
Date:   Fri,  3 Mar 2023 16:44:58 -0500
Message-Id: <20230303214531.1450154-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 64a68158738ec8f520347144352f7a09bdb9e169 ]

Smatch Warns:
drivers/iio/accel/mma9551_core.c:299
	mma9551_read_config_word() error: uninitialized symbol 'v'.

When (offset >= 1 << 12) is true mma9551_transfer() will return -EINVAL
without 'v' being initialized, so check for the error and return.

Note: No actual bug as caller checks the return value and does not
use the parameter in the problem case.

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20230126153610.3586243-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index 413610a749c24..9023c07bb57b4 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -296,9 +296,12 @@ int mma9551_read_config_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(mma9551_read_config_word);
 
-- 
2.39.2

