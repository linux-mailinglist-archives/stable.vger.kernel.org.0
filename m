Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E8359E2C6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351484AbiHWLRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357890AbiHWLQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:16:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17E9BD4D7;
        Tue, 23 Aug 2022 02:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68F86B8105C;
        Tue, 23 Aug 2022 09:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9725C433C1;
        Tue, 23 Aug 2022 09:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246428;
        bh=V4swQTkqJKGedbpvM0nwVjdeiD3qYt6LmveHrb5YIZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcUxUiLvae3V2AhuLDyVVEkwdAil5ri/ncQyVlABfLzy8B2tbp0LX67dCQXGH33kR
         gqcE9fs6c45XROJkKWBO2XQafSHkMpqfaGNEiUvAZiqlTrB4R3Fq9hJKVWITIrq685
         +sKu+fhEmtuKd3j4NnVvimy/okafvilgYMYFPuoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/389] media: hdpvr: fix error value returns in hdpvr_read
Date:   Tue, 23 Aug 2022 10:23:05 +0200
Message-Id: <20220823080120.076107491@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 7849f1fbbcc4..4f1505b94338 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -409,7 +409,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 	struct hdpvr_device *dev = video_drvdata(file);
 	struct hdpvr_buffer *buf = NULL;
 	struct urb *urb;
-	unsigned int ret = 0;
+	int ret = 0;
 	int rem, cnt;
 
 	if (*pos)
-- 
2.35.1



