Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F012960A5E9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbiJXMbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiJXM3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4E587FBA;
        Mon, 24 Oct 2022 05:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26989612D4;
        Mon, 24 Oct 2022 11:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CEAC433C1;
        Mon, 24 Oct 2022 11:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612347;
        bh=WuQ+a24g+3pSZIPtjL7lLPfmIo0ARrrOYfngw46IVJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bejunlF9N+hDU0wO5wuZL0rBH8wqvpFWJVgGl2K5u/qZaCHTB69KzX4CT8d4qa6Xj
         rmi5vM/DGb2BQsj+kgiSJHr4XY0oxvDxyPUz2kwGE+UvwM03h+Bp55MEFBKD60rfyv
         S0HLQBQebMNAtG2hSEAYeLTOKZwtd2gD7lSg+lWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Albert Briscoe <albertsbriscoe@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 136/210] usb: gadget: function: fix dangling pnp_string in f_printer.c
Date:   Mon, 24 Oct 2022 13:30:53 +0200
Message-Id: <20221024113001.407237479@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Albert Briscoe <albertsbriscoe@gmail.com>

[ Upstream commit 24b7ba2f88e04800b54d462f376512e8c41b8a3c ]

When opts->pnp_string is changed with configfs, new memory is allocated for
the string. It does not, however, update dev->pnp_string, even though the
memory is freed. When rquesting the string, the host then gets old or
corrupted data rather than the new string. The ieee 1284 id string should
be allowed to change while the device is connected.

The bug was introduced in commit fdc01cc286be ("usb: gadget: printer:
Remove pnp_string static buffer"), which changed opts->pnp_string from a
char[] to a char*.
This patch changes dev->pnp_string from a char* to a char** pointing to
opts->pnp_string.

Fixes: fdc01cc286be ("usb: gadget: printer: Remove pnp_string static buffer")
Signed-off-by: Albert Briscoe <albertsbriscoe@gmail.com>
Link: https://lore.kernel.org/r/20220911223753.20417-1-albertsbriscoe@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_printer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index 4e0afeabe8b8..830cc2bb0fdf 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -91,7 +91,7 @@ struct printer_dev {
 	u8			printer_cdev_open;
 	wait_queue_head_t	wait;
 	unsigned		q_len;
-	char			*pnp_string;	/* We don't own memory! */
+	char			**pnp_string;	/* We don't own memory! */
 	struct usb_function	function;
 };
 
@@ -967,16 +967,16 @@ static int printer_func_setup(struct usb_function *f,
 			if ((wIndex>>8) != dev->interface)
 				break;
 
-			if (!dev->pnp_string) {
+			if (!*dev->pnp_string) {
 				value = 0;
 				break;
 			}
-			value = strlen(dev->pnp_string);
+			value = strlen(*dev->pnp_string);
 			buf[0] = (value >> 8) & 0xFF;
 			buf[1] = value & 0xFF;
-			memcpy(buf + 2, dev->pnp_string, value);
+			memcpy(buf + 2, *dev->pnp_string, value);
 			DBG(dev, "1284 PNP String: %x %s\n", value,
-			    dev->pnp_string);
+			    *dev->pnp_string);
 			break;
 
 		case GET_PORT_STATUS: /* Get Port Status */
@@ -1439,7 +1439,7 @@ static struct usb_function *gprinter_alloc(struct usb_function_instance *fi)
 	kref_init(&dev->kref);
 	++opts->refcnt;
 	dev->minor = opts->minor;
-	dev->pnp_string = opts->pnp_string;
+	dev->pnp_string = &opts->pnp_string;
 	dev->q_len = opts->q_len;
 	mutex_unlock(&opts->lock);
 
-- 
2.35.1



