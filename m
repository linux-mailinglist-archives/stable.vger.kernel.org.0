Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43487608845
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiJVIMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiJVIKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:10:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6174C371A3;
        Sat, 22 Oct 2022 00:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DC4AB82E16;
        Sat, 22 Oct 2022 07:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0B0C433D6;
        Sat, 22 Oct 2022 07:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425268;
        bh=0yp0MeoCQn55dZ0Ly+Cfe8r8xQVfv9yqt30m368kJ1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNRRZpj/NdGrNzVOHCPC/mqU7YdwfAc2Ur60N2gvwlPkPXYDxGk6H2UmyCPZ1Tb5b
         Tp8NP+phee5xO1yNggmN34Xb0l/VavgLmaImWJ1Gy1ZLQdGsRp26nlV53SB/ooTcD8
         yt4DqjLNNZ/KjFxTmg7Ed1BmhuLVhwRBtQJYV6tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Albert Briscoe <albertsbriscoe@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 445/717] usb: gadget: function: fix dangling pnp_string in f_printer.c
Date:   Sat, 22 Oct 2022 09:25:24 +0200
Message-Id: <20221022072517.968783270@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index abec5c58f525..a881c69b1f2b 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -89,7 +89,7 @@ struct printer_dev {
 	u8			printer_cdev_open;
 	wait_queue_head_t	wait;
 	unsigned		q_len;
-	char			*pnp_string;	/* We don't own memory! */
+	char			**pnp_string;	/* We don't own memory! */
 	struct usb_function	function;
 };
 
@@ -1000,16 +1000,16 @@ static int printer_func_setup(struct usb_function *f,
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
@@ -1475,7 +1475,7 @@ static struct usb_function *gprinter_alloc(struct usb_function_instance *fi)
 	kref_init(&dev->kref);
 	++opts->refcnt;
 	dev->minor = opts->minor;
-	dev->pnp_string = opts->pnp_string;
+	dev->pnp_string = &opts->pnp_string;
 	dev->q_len = opts->q_len;
 	mutex_unlock(&opts->lock);
 
-- 
2.35.1



