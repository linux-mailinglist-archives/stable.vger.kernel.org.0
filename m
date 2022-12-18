Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723A76503C6
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiLRRIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiLRRGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 12:06:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2E9C74F;
        Sun, 18 Dec 2022 08:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF1BB60C99;
        Sun, 18 Dec 2022 16:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319CEC433F2;
        Sun, 18 Dec 2022 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380580;
        bh=noPrCegBTp9PV+M7uhFDhcaViqTvtzP0b7QtO8g6MaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTNMW8j2j9CEA0PJghxqnUOFYoj4d8Jott8+WPURvAREOHjwfiIP8cCQj0QBU3UXR
         mR+M0xzVsV6yCVPAiOUjWtxY1qp1rfwbrJJxn9SKdNSKjzLGON71eLGKYEZUn1JFEQ
         eoXnV8jNv9Vbj8N4bH56FD03VyL4kyQ8HbA9GDPacGvSPCcLFzBXlzrhOMAliPy7fP
         Bkdag0pzm0hoj7vEURb+cpMmEyeQQ0j1MSH8FLGHuNmZnWV8wiQsxOibWL882Iw5KP
         VlFC2/38iCHKkYa7c6kvpLk/95CsODTKXtZe4Z8d2nh8Ag5QqxrvC3rBStNkadJ3ju
         /uJK33JlK85fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+9ca7a12fd736d93e0232@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/23] media: si470x: Fix use-after-free in si470x_int_in_callback()
Date:   Sun, 18 Dec 2022 11:21:48 -0500
Message-Id: <20221218162149.935047-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162149.935047-1-sashal@kernel.org>
References: <20221218162149.935047-1-sashal@kernel.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 7d21e0b1b41b21d628bf2afce777727bd4479aa5 ]

syzbot reported use-after-free in si470x_int_in_callback() [1].  This
indicates that urb->context, which contains struct si470x_device
object, is freed when si470x_int_in_callback() is called.

The cause of this issue is that si470x_int_in_callback() is called for
freed urb.

si470x_usb_driver_probe() calls si470x_start_usb(), which then calls
usb_submit_urb() and si470x_start().  If si470x_start_usb() fails,
si470x_usb_driver_probe() doesn't kill urb, but it just frees struct
si470x_device object, as depicted below:

si470x_usb_driver_probe()
  ...
  si470x_start_usb()
    ...
    usb_submit_urb()
    retval = si470x_start()
    return retval
  if (retval < 0)
    free struct si470x_device object, but don't kill urb

This patch fixes this issue by killing urb when si470x_start_usb()
fails and urb is submitted.  If si470x_start_usb() fails and urb is
not submitted, i.e. submitting usb fails, it just frees struct
si470x_device object.

Reported-by: syzbot+9ca7a12fd736d93e0232@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=94ed6dddd5a55e90fd4bab942aa4bb297741d977 [1]
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 95581a847619..5710f362a26d 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -736,8 +736,10 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 
 	/* start radio */
 	retval = si470x_start_usb(radio);
-	if (retval < 0)
+	if (retval < 0 && !radio->int_in_running)
 		goto err_buf;
+	else if (retval < 0)	/* in case of radio->int_in_running == 1 */
+		goto err_all;
 
 	/* set initial frequency */
 	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
-- 
2.35.1

