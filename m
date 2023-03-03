Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8500D6AA29E
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjCCVtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjCCVsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:48:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1B6420B;
        Fri,  3 Mar 2023 13:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E2A61931;
        Fri,  3 Mar 2023 21:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB3EC4339C;
        Fri,  3 Mar 2023 21:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879834;
        bh=s+oxcJSBZ8YNHVi15Y9HIZrKQpkfo0EPqvo/HoBvzpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9Iprh1XMXDWbqgbm4IV/v7pmoEl0/2GQzQSOXtZsNkOPHRCA+j1VsPs6uanxgn+o
         r2N0vZ8YpPhwmFaY9zM763n59LhO/I0d8kq3o4rdgjQpvREeRvxiqRoLI3Si7jgkY6
         ZJyB3BywaP3WezphMC/D5uLzqTOM8zFZkwsnTYNA0aFTeMV2yjIdT9g9KBsnnzUI26
         Mw58V7DMNI5tSO8hf296qGU0FWoCaREuPYT+G6lHE99lL+cbPHDzCIl2Pw/5YmikQB
         MCxc9GqiJRnR2hYX3RvxqVWzP4tXc6lTObZ0tqdjvt9CQEJ4V3I/ORmM6EPG6VTq3b
         HdU6QF8dxfcMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 19/60] iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
Date:   Fri,  3 Mar 2023 16:42:33 -0500
Message-Id: <20230303214315.1447666-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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

