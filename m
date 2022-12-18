Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F83365040C
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiLRRNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiLRRLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 12:11:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DE613DF8;
        Sun, 18 Dec 2022 08:23:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28330B80BA7;
        Sun, 18 Dec 2022 16:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4C3C433F1;
        Sun, 18 Dec 2022 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380636;
        bh=3ntBw2N1j5Ww+dKL3/4PPJIwX5FXt64fDouDRz6ISCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nF9ZCnTE3iMDxMFXnUWopzJtzWFl2EXpytEMUn/hxZUoxuHtgAUdzvU6mg7efHnK7
         4SSAoG2dPfFOv7/93TO/LnXwFvL/EvTrFHU4kRw/DKthwaQ5z040igkDViES6lwFoc
         Q0znwA/6X6/UdRTNBxE08YqHJMu1w67MufYjW3YHj4FNGYv/Ck5tj5t4VtzzgWTnrg
         jrNXEybJIACt5fXZ/hG3wNlCqLX1CWYjB3GYWLTNt5OHh1IMPSwiJBEPBggAZC3xgd
         +7woLxh0p+vbXqMmauzL3LKoNX6mfbO/KxjfaRAGh0QtFtsvPTYtGhVJrQEVBUJgPC
         yOXrxe7lSLRPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+9ca7a12fd736d93e0232@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 19/20] media: si470x: Fix use-after-free in si470x_int_in_callback()
Date:   Sun, 18 Dec 2022 11:23:04 -0500
Message-Id: <20221218162305.935724-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162305.935724-1-sashal@kernel.org>
References: <20221218162305.935724-1-sashal@kernel.org>
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
index a8a0ff9a1f83..6724c5287cc3 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -741,8 +741,10 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 
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

