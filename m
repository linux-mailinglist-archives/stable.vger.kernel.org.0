Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDB76557DC
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbiLXBmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbiLXBl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:41:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263C556D7C;
        Fri, 23 Dec 2022 17:33:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9794ECE1D03;
        Sat, 24 Dec 2022 01:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E081C433F0;
        Sat, 24 Dec 2022 01:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845612;
        bh=a5WBbi6MJo+w2IIzowc3UGampdUoFPDmqlBd9eh11Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N73qg9Xqefki2WugkQ0NVBpxIG+fhVY0kNw0NwaEjUrCTY0nUeNVnPnCRb9iqADgB
         e5lUI2zlXB03jJ+AAo3biATFVA2QfLzXpZgc57pcE+HYZYRDDbsPUYUrUyCSDnpIvS
         RtVfoWCgIxzCccigK/1ctWk/+xqwlPNlpiCBYn/e3y5N8bFOcbq5ioCKGk4cl++Wrw
         KfVFgqAJ1HUUdGQwhy6ujmBz7xXIHcRCY+mhAeoOcxQN3s9cOBooH14zmKWzeiTDxK
         JNg+cS7j4z8tIirRTCqYmNTXvteqxKx/PqLuTgSvEL8O7AvJ7eqpIlBtuw99wW9Bhj
         yK/SC6RkcIc3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, valentina.manea.m@gmail.com,
        shuah@kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/4] usb/usbip: Fix v_recv_cmd_submit() to use PIPE_BULK define
Date:   Fri, 23 Dec 2022 20:33:24 -0500
Message-Id: <20221224013325.393931-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013325.393931-1-sashal@kernel.org>
References: <20221224013325.393931-1-sashal@kernel.org>
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

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit dd65a243a915ca319ed5fee9161a168c836fa2f2 ]

Fix v_recv_cmd_submit() to use PIPE_BULK define instead of hard coded
values. This also fixes the following signed integer overflow error
reported by cppcheck. This is not an issue since pipe is unsigned int.
However, this change improves the code to use proper define.

drivers/usb/usbip/vudc_rx.c:152:26: error: Signed integer overflow for expression '3<<30'. [integerOverflow]
 urb_p->urb->pipe &= ~(3 << 30);

In addition, add a build time check for PIPE_BULK != 3 as the code path
depends on PIPE_BULK = 3.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20221110194738.38514-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vudc_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/vudc_rx.c b/drivers/usb/usbip/vudc_rx.c
index d020e72b3122..7c5d09ee3ef8 100644
--- a/drivers/usb/usbip/vudc_rx.c
+++ b/drivers/usb/usbip/vudc_rx.c
@@ -161,7 +161,9 @@ static int v_recv_cmd_submit(struct vudc *udc,
 	urb_p->urb->status = -EINPROGRESS;
 
 	/* FIXME: more pipe setup to please usbip_common */
-	urb_p->urb->pipe &= ~(3 << 30);
+	BUILD_BUG_ON_MSG(PIPE_BULK != 3, "PIPE_* doesn't range from 0 to 3");
+
+	urb_p->urb->pipe &= ~(PIPE_BULK << 30);
 	switch (urb_p->ep->type) {
 	case USB_ENDPOINT_XFER_BULK:
 		urb_p->urb->pipe |= (PIPE_BULK << 30);
-- 
2.35.1

