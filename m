Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5486AA1DD
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjCCVoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjCCVnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:43:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E841E65C6A;
        Fri,  3 Mar 2023 13:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E3F061929;
        Fri,  3 Mar 2023 21:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F58C433EF;
        Fri,  3 Mar 2023 21:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879714;
        bh=1tYfkklAt84DLqXG8UKW3jbjYmFY+1EiJ+dj4OS2AJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Irr9C3L1p/VGB8P3UX/apmMnbM8stBghaBdPBsAYPKXoDTAhXsMCtpuzrgkW2e8TO
         A5VUeJ1Ov7HD5NSja1TETX6rrbA33dDKfGgI2SiV/JwEGfmQ3V85+GRSk89Tg2Y5kt
         WYQg3/2Oo/ilgOgFaj+90VMZFdccOAc5rwQwdNCbqD+Bh1S0Z1DU8bQKpKyQdgi2P6
         p7OBKQsft5hNjMc1l8x39RieclK37SvkUjwPpf5p98UjfGFZqXestINt0E3Z1NDc4u
         Uys23KWEYXUkcJRuukoKx1t0/3XjezoKoKTZ3ZoJ7fHnSoUDoSw6tgdb2fdWqg48/Z
         0YVvmqEq/6zDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 23/64] iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()
Date:   Fri,  3 Mar 2023 16:40:25 -0500
Message-Id: <20230303214106.1446460-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 86437ddc5ca18..b898f865fb875 100644
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
 EXPORT_SYMBOL_NS(mma9551_read_config_word, IIO_MMA9551);
 
-- 
2.39.2

