Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF88593969
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbiHOShu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243575AbiHOSgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:36:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC732DA92;
        Mon, 15 Aug 2022 11:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0961E6068D;
        Mon, 15 Aug 2022 18:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EB8C433C1;
        Mon, 15 Aug 2022 18:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587792;
        bh=jhB3BcC4WMae6aGnSw8cXRASOVkW/NucMwW8lJkgSus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM3qRwLO9h9THO7BvI5+T7d28id8iR+JV/LPBweL0M/ZZgsrfxt9ylY4XSDxQNdN/
         CpVmEYsfNaHLt6lFSRVLkzvWLxKLkhqkssE8lO7czx0wrxCcbZvucmG1hBOn+x0V+y
         V5Sc2DcgaG5pKtqsUUg8taTEGL501b/GoE/kbZFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Baker <len.baker@gmx.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/779] drivers/iio: Remove all strcpy() uses
Date:   Mon, 15 Aug 2022 19:57:21 +0200
Message-Id: <20220815180345.695878214@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Len Baker <len.baker@gmx.com>

[ Upstream commit d722f1e06fbc53eb369b39646945c1fa92068e74 ]

strcpy() performs no bounds checking on the destination buffer. This
could result in linear overflows beyond the end of the buffer, leading
to all kinds of misbehaviors. So, remove all the uses and add
devm_kstrdup() or devm_kasprintf() instead.

Also, modify the "for" loop conditions to clarify the access to the
st->orientation.rotation buffer.

This patch is an effort to clean up the proliferation of str*()
functions in the kernel and a previous step in the path to remove
the strcpy function from the kernel entirely [1].

[1] https://github.com/KSPP/linux/issues/88

Signed-off-by: Len Baker <len.baker@gmx.com>
Link: https://lore.kernel.org/r/20210815174204.126593-1-len.baker@gmx.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_magn.c | 36 +++++++++++++---------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_magn.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_magn.c
index f282e9cc34c5..6aee6c989485 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_magn.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_magn.c
@@ -261,6 +261,7 @@ int inv_mpu_magn_set_rate(const struct inv_mpu6050_state *st, int fifo_rate)
  */
 int inv_mpu_magn_set_orient(struct inv_mpu6050_state *st)
 {
+	struct device *dev = regmap_get_device(st->map);
 	const char *orient;
 	char *str;
 	int i;
@@ -279,22 +280,27 @@ int inv_mpu_magn_set_orient(struct inv_mpu6050_state *st)
 		st->magn_orient.rotation[4] = st->orientation.rotation[1];
 		st->magn_orient.rotation[5] = st->orientation.rotation[2];
 		/* z <- -z */
-		for (i = 0; i < 3; ++i) {
-			orient = st->orientation.rotation[6 + i];
-			/* use length + 2 for adding minus sign if needed */
-			str = devm_kzalloc(regmap_get_device(st->map),
-					   strlen(orient) + 2, GFP_KERNEL);
-			if (str == NULL)
+		for (i = 6; i < 9; ++i) {
+			orient = st->orientation.rotation[i];
+
+			/*
+			 * The value is negated according to one of the following
+			 * rules:
+			 *
+			 * 1) Drop leading minus.
+			 * 2) Leave 0 as is.
+			 * 3) Add leading minus.
+			 */
+			if (orient[0] == '-')
+				str = devm_kstrdup(dev, orient + 1, GFP_KERNEL);
+			else if (!strcmp(orient, "0"))
+				str = devm_kstrdup(dev, orient, GFP_KERNEL);
+			else
+				str = devm_kasprintf(dev, GFP_KERNEL, "-%s", orient);
+			if (!str)
 				return -ENOMEM;
-			if (strcmp(orient, "0") == 0) {
-				strcpy(str, orient);
-			} else if (orient[0] == '-') {
-				strcpy(str, &orient[1]);
-			} else {
-				str[0] = '-';
-				strcpy(&str[1], orient);
-			}
-			st->magn_orient.rotation[6 + i] = str;
+
+			st->magn_orient.rotation[i] = str;
 		}
 		break;
 	default:
-- 
2.35.1



