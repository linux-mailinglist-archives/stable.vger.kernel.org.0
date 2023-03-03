Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3566AA1CE
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjCCVnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjCCVmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC1B70434;
        Fri,  3 Mar 2023 13:41:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED41CB819FF;
        Fri,  3 Mar 2023 21:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E86C433D2;
        Fri,  3 Mar 2023 21:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879711;
        bh=s+oxcJSBZ8YNHVi15Y9HIZrKQpkfo0EPqvo/HoBvzpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTiShyTO8SdZCMWfjNmN8Xs7/KThr+w+mhe0ImTe4wkE8v8ztdLH4M+ObJ0rkeXKl
         VN/S/0b6PyLj81MD8g1d+eR3iYxDosQZOsZUHtEOZVq0RZgBaAbjRF143cqj2e/dvs
         w9eWhXAigZaPpSzmDvKxb0tp7C9MB4rEqDaLqPB8OesLdbyNbbRDgyqZxiYHSZofZM
         2iWekRX3QUjXUtIMk719evqJvz5YiME6yQDlqxa5b/K8TxQI5WAy/4yn2Biy8t0fTK
         a5RHuQs4q96bvH+upaZhC9XAYIAe4G+/HIalCSt7d6Z4JhltR+XzJXtfcaxkD8Q4lj
         b7NH7L4sDbdcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 22/64] iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
Date:   Fri,  3 Mar 2023 16:40:24 -0500
Message-Id: <20230303214106.1446460-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
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

[ Upstream commit e56d2c34ce9dc122b1a618172ec0e05e50adb9e9 ]

Smatch Warns: drivers/iio/accel/mma9551_core.c:357
	mma9551_read_status_word() error: uninitialized symbol 'v'.

When (offset >= 1 << 12) is true mma9551_transfer() will return -EINVAL
without 'v' being initialized, so check for the error and return.

Note: Not a bug as such because the caller checks return value and
doesn't not use this parameter in the problem case.

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20230126152147.3585874-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index 64ca7d7a9673d..86437ddc5ca18 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -354,9 +354,12 @@ int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_NS(mma9551_read_status_word, IIO_MMA9551);
 
-- 
2.39.2

