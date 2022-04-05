Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD44F24F2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiDEHnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiDEHmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:42:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067BA92301;
        Tue,  5 Apr 2022 00:40:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52706CE1B5F;
        Tue,  5 Apr 2022 07:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604EEC340EE;
        Tue,  5 Apr 2022 07:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144403;
        bh=2RbXYmvmH8YXbVaPJDYwn2mzYNzBSGuxgLv5o+qTaJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfPsm14CypslZDmxUeLcRgQ1Me0+Kr6LkMJ0lTTpGqqtoiRem7aebEyP7ql982gFy
         gxNs5DDE4+N+oJWYDa3q0T37/c98Wz2qcEiaODnY/IVX8FGu8XQXit3A6xqQWJsz81
         7ahcua0i+q+IljDGKvLTfmbeGX+KWVGc04LcTdVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 0032/1126] iio: imu: st_lsm6dsx: use dev_to_iio_dev() to get iio_dev struct
Date:   Tue,  5 Apr 2022 09:12:59 +0200
Message-Id: <20220405070408.497203155@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

commit 6270bf1f0197739a9cddaf0a40699a99b7357cb5 upstream.

dev_get_drvdata() on iio_dev->dev no longer returns the iio_dev.
Use dev_to_iio_dev() to get iio_dev struct.

Fixes: 8b7651f25962 ("iio: iio_device_alloc(): Remove unnecessary self drvdata")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/1645702191-9400-1-git-send-email-haibo.chen@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1633,7 +1633,7 @@ st_lsm6dsx_sysfs_sampling_frequency_avai
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_get_drvdata(dev));
+	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_to_iio_dev(dev));
 	const struct st_lsm6dsx_odr_table_entry *odr_table;
 	int i, len = 0;
 
@@ -1651,7 +1651,7 @@ static ssize_t st_lsm6dsx_sysfs_scale_av
 					    struct device_attribute *attr,
 					    char *buf)
 {
-	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_get_drvdata(dev));
+	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_to_iio_dev(dev));
 	const struct st_lsm6dsx_fs_table_entry *fs_table;
 	struct st_lsm6dsx_hw *hw = sensor->hw;
 	int i, len = 0;


