Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F9759A206
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351673AbiHSQJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351206AbiHSQHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:07:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA67C1ADBA;
        Fri, 19 Aug 2022 08:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EADDB8280D;
        Fri, 19 Aug 2022 15:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C044FC433D6;
        Fri, 19 Aug 2022 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924581;
        bh=a31WYOj3u0YxhhWWPGE8uaQmFHl6yu7OQLekdTH58ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twpV1CETAnptV2FXnMksPW2irnZRCMJjbxboiQxnP2qkT5IIdi9r8DuGwcKSxOmbq
         TmbzrCA+qj8HZwRvzEAv9FSOcEhWCPNjh5f5dPrcr9Yxv6KtNciKC+JWGZFgYLi3J4
         jOAkthVIxBIk+RMJkDxC2qTgziaL8+GmcxE28zw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/545] media: hdpvr: fix error value returns in hdpvr_read
Date:   Fri, 19 Aug 2022 17:39:16 +0200
Message-Id: <20220819153837.686619755@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 60e57e0f1927..fd7d2a9d0449 100644
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



