Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D255359D78F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiHWJjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351689AbiHWJim (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:38:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB43225EB1;
        Tue, 23 Aug 2022 01:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D11D16153C;
        Tue, 23 Aug 2022 08:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B084AC433D6;
        Tue, 23 Aug 2022 08:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243999;
        bh=3nNFgxHraRJWA0ShV22x8RUpKDKlePeNDiV/IlDMamg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQmJUufWNUijtmn5P/GDwEbN+d+WfmB9xU8INGKmbJ4rffpVfEXLB85N8Wa2cHWSM
         liD/nOlxM1VIZD1QKqQYnLiJ30FPXVS6D9T75s7/2EPmiLsJZPTbGXBkwgDc3F0Dkz
         jyaRVG12Ign2O+Kf7djQ0ifEklCM+gU+28q3BY+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/229] media: hdpvr: fix error value returns in hdpvr_read
Date:   Tue, 23 Aug 2022 10:23:47 +0200
Message-Id: <20220823080056.079825043@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 359c27c6ddbde404f44a9c0d3ec88ccd1e2042f2 ]

Error return values are supposed to be negative in hdpvr_read. Most
error returns are currently handled via an unsigned integer "ret". When
setting a negative error value to "ret", the value actually becomes a
large positive value, because "ret" is unsigned. Later on, the "ret"
value is returned. But as ssize_t is a 64-bit signed number, the error
return value stays a large positive integer instead of a negative
integer. This can cause an error value to be interpreted as the read
size, which can cause a buffer overread for applications relying on the
returned size.

Fixes: 9aba42efe85b ("V4L/DVB (11096): V4L2 Driver for the Hauppauge HD PVR usb capture device")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 1cecb37e16d2..59bd44736fae 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -413,7 +413,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 	struct hdpvr_device *dev = video_drvdata(file);
 	struct hdpvr_buffer *buf = NULL;
 	struct urb *urb;
-	unsigned int ret = 0;
+	int ret = 0;
 	int rem, cnt;
 
 	if (*pos)
-- 
2.35.1



