Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34416B48BD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbjCJPG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjCJPFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:05:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1C76C6BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:59:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E690DB82316
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CB3C4339C;
        Fri, 10 Mar 2023 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460286;
        bh=GOO+5daKcvgCJqX2TW7Ow94BY1PLOJrsyOhdMpXME5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1vSOlF6tj9jNe72lfJD8rLhCTduE9XJKT3rfMc265tKcXiGrXNMM28LPzy6Gpw2v
         JaDUDJQN0DeqE099cTte2GCL5m99EOiA0bXe7zVIKcY/hL53qV7jbc/ixBjr2RH0cP
         brr4+qk+jvcXCLcXtLmAwf9zyLokYVDJf1/6+B+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/529] media: i2c: ov7670: 0 instead of -EINVAL was returned
Date:   Fri, 10 Mar 2023 14:37:00 +0100
Message-Id: <20230310133817.789339279@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 6a4c664539e6de9b32b65ddcf767ec1bcc1d7f8a ]

If the media bus is unsupported, then return -EINVAL. Instead it
returned 'ret' which happened to be 0.

This fixes a smatch warning:

ov7670.c:1843 ov7670_parse_dt() warn: missing error code? 'ret'

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 01b8444828fc ("media: v4l2: i2c: ov7670: Implement OF mbus configuration")
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 154776d0069ea..e47800cb6c0f7 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1824,7 +1824,7 @@ static int ov7670_parse_dt(struct device *dev,
 
 	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
 		dev_err(dev, "Unsupported media bus type\n");
-		return ret;
+		return -EINVAL;
 	}
 	info->mbus_config = bus_cfg.bus.parallel.flags;
 
-- 
2.39.2



