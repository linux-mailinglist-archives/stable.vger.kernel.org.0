Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFD86502CB
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiLRQx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiLRQwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:52:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BD51AF21;
        Sun, 18 Dec 2022 08:18:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1657860DCC;
        Sun, 18 Dec 2022 16:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9052AC433F2;
        Sun, 18 Dec 2022 16:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380308;
        bh=iTuO9QfbW5dOdxV+MuKHqJvpops+DbnddqpcwT5+1hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4SeKNFcknSagB7FEZ3CWV1FSetvzZSL4dIV5p8+8dQ7Q8qtH0nQhZf+nPtNQ/F1N
         jXGCBaD2hwmtyF7K5QAJXPRC2AoO7DUbI92tfluYk6bj1RLd883WSJ78sRFTpr0Jjp
         5ea9Wwfe3cck2VIIDuAGWFwccbhMjjFqZzo6YMzSjITBs825Du5qqK8fnauzVrR9aS
         BplLvrw48NEzyWq+N/IH6usO4g6RIokni9PuSXwhQWeeXbAwoxFIU7VB5QykxsZde8
         3IFWK2YyQ+SUyHJO4zSdIAlMFWcQ9+eAXHB2dJ6GXiBC/byJqUcfCZNEXEfKT1KI+N
         ka2U6hv1pJaUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+9ca7a12fd736d93e0232@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 38/39] media: si470x: Fix use-after-free in si470x_int_in_callback()
Date:   Sun, 18 Dec 2022 11:15:58 -0500
Message-Id: <20221218161559.932604-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
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
index 3f8634a46573..1365ae732b79 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -733,8 +733,10 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 
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

