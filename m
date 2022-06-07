Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3F540EA6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353310AbiFGSyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354179AbiFGSqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622331238A9;
        Tue,  7 Jun 2022 11:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E2561804;
        Tue,  7 Jun 2022 18:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D36C385A5;
        Tue,  7 Jun 2022 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624814;
        bh=ogHTnG+5vM5g7tkfmQn9/Rp7sQo1fghtNC8wa05qGGk=;
        h=From:To:Cc:Subject:Date:From;
        b=YbpeE+LCW8GBa1paNKO0PeaiUWha5+x9AMaAmhCZnU+LfyZuMu/tYaN5t8clyxP7T
         855vgHXEmwFli9z4f4lYcH+0/tUt6xUGVEMChTZErksB4BqVDhj0x7DBkzLrOn4gmc
         al3zC5mFYr1t6m9jO0AmRJd2by6lDwigEtLUJ8XOLp9ijkfzVaSO5UhZAiOCOf84iy
         Y8qNn65TuTYqpU8sM4H42HqTFeWjqVqMTuUQVbjbrWCVkl8duLrDhlcwZ1GuGiu67D
         IS4+p2ouqjWUTuTB3ql0EkcKJ82vqLsgbQUZl97G6wGdpHScdt5+GLjdgKRquVkFT4
         uWISRN/QoSakw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/34] iio: dummy: iio_simple_dummy: check the return value of kstrdup()
Date:   Tue,  7 Jun 2022 13:59:36 -0400
Message-Id: <20220607180011.481266-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit ba93642188a6fed754bf7447f638bc410e05a929 ]

kstrdup() is also a memory allocation-related function, it returns NULL
when some memory errors happen. So it is better to check the return
value of it so to catch the memory error in time. Besides, there should
have a kfree() to clear up the allocation if we get a failure later in
this function to prevent memory leak.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Link: https://lore.kernel.org/r/tencent_C920CFCC33B9CC1C63141FE1334A39FF8508@qq.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dummy/iio_simple_dummy.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/dummy/iio_simple_dummy.c b/drivers/iio/dummy/iio_simple_dummy.c
index 6cb02299a215..18cfe1cb7a40 100644
--- a/drivers/iio/dummy/iio_simple_dummy.c
+++ b/drivers/iio/dummy/iio_simple_dummy.c
@@ -568,10 +568,9 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	struct iio_sw_device *swd;
 
 	swd = kzalloc(sizeof(*swd), GFP_KERNEL);
-	if (!swd) {
-		ret = -ENOMEM;
-		goto error_kzalloc;
-	}
+	if (!swd)
+		return ERR_PTR(-ENOMEM);
+
 	/*
 	 * Allocate an IIO device.
 	 *
@@ -583,7 +582,7 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	indio_dev = iio_device_alloc(sizeof(*st));
 	if (!indio_dev) {
 		ret = -ENOMEM;
-		goto error_ret;
+		goto error_free_swd;
 	}
 
 	st = iio_priv(indio_dev);
@@ -614,6 +613,10 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	 *    indio_dev->name = spi_get_device_id(spi)->name;
 	 */
 	indio_dev->name = kstrdup(name, GFP_KERNEL);
+	if (!indio_dev->name) {
+		ret = -ENOMEM;
+		goto error_free_device;
+	}
 
 	/* Provide description of available channels */
 	indio_dev->channels = iio_dummy_channels;
@@ -630,7 +633,7 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 
 	ret = iio_simple_dummy_events_register(indio_dev);
 	if (ret < 0)
-		goto error_free_device;
+		goto error_free_name;
 
 	ret = iio_simple_dummy_configure_buffer(indio_dev);
 	if (ret < 0)
@@ -647,11 +650,12 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	iio_simple_dummy_unconfigure_buffer(indio_dev);
 error_unregister_events:
 	iio_simple_dummy_events_unregister(indio_dev);
+error_free_name:
+	kfree(indio_dev->name);
 error_free_device:
 	iio_device_free(indio_dev);
-error_ret:
+error_free_swd:
 	kfree(swd);
-error_kzalloc:
 	return ERR_PTR(ret);
 }
 
-- 
2.35.1

