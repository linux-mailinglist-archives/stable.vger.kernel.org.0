Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41566AA3B2
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbjCCWDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbjCCWCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:02:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9484512056;
        Fri,  3 Mar 2023 13:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7DDBB81A3A;
        Fri,  3 Mar 2023 21:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E858EC433EF;
        Fri,  3 Mar 2023 21:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880190;
        bh=k5XWIl5XB4f65o6A0XZFfzI5aSXS0CJa1Wdvb80QDis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX/3Ywp1T1+8WL3aeF40MQEkhgYDco/e/vix+XgwXoT/R7BJSi4mT6iymKqRV/J7u
         phdq0xYmQMdLQ/SjeC2anWDwf1WtHXOAyw2R4drpWXoU64EpREy6cbjbOVHKxGkOZ3
         HS/PYV8uq6x8lLd3LXi+zTTv6t5gBXyNbLeuo7OIlCCGUbGHKFbwQNnzJ/1Qfv+CXe
         POnWuBzXRUvoVWvIYq+0k7y78Br9buhUny6Qsj38nTjm2fejkNKNz7DZ9xcEfClCLl
         H0/PhBJGZ55fLl1IDlfMsRusuI5pnsUT33xWm1Nx5XCnF/yTfrqTMSpx6MLRYxBxH3
         BnciNfxXEju+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/11] iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
Date:   Fri,  3 Mar 2023 16:49:32 -0500
Message-Id: <20230303214938.1454767-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214938.1454767-1-sashal@kernel.org>
References: <20230303214938.1454767-1-sashal@kernel.org>
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
index c34c5ce8123b0..b4bbc83be4310 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -362,9 +362,12 @@ int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(mma9551_read_status_word);
 
-- 
2.39.2

