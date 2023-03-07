Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48076AF09D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjCGScr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCGScP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:32:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83598A0B0C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B83261526
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0326DC433D2;
        Tue,  7 Mar 2023 18:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213488;
        bh=RONamiWUnS1jsHwEzeFMADHKZ8TSz9JNW65MKys36g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bD5a9datYhntdPIRZ29XLDDFa8Jau2vDfy0QNfsOVySJTdEuS9qJBr3yrzydnJp2S
         o4xx+lWK507egVIAj9iedb2BTSFaVNLFdefORjPaLB1pOpgqb+LXy8ZGM3uqBKoJib
         3vP3MXHYT6Lb+5QTDqnvx2Pw8wbkX7VD67gbEsoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 522/885] media: i2c: ov7670: 0 instead of -EINVAL was returned
Date:   Tue,  7 Mar 2023 17:57:36 +0100
Message-Id: <20230307170025.141158265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 4b9b156b53c7a..c06364c1cbd1b 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1841,7 +1841,7 @@ static int ov7670_parse_dt(struct device *dev,
 
 	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
 		dev_err(dev, "Unsupported media bus type\n");
-		return ret;
+		return -EINVAL;
 	}
 	info->mbus_config = bus_cfg.bus.parallel.flags;
 
-- 
2.39.2



