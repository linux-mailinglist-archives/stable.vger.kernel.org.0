Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A79594D00
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiHPAgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiHPAeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:34:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DA23ECED;
        Mon, 15 Aug 2022 13:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9CEAB8114A;
        Mon, 15 Aug 2022 20:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDBCC433D7;
        Mon, 15 Aug 2022 20:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595830;
        bh=K0NC5vh2wk+9F51YPideuNlQiJvHDrvX4q0437WVoOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKoTnvaLsogOftVMxQxX9z0JbSG0nGZZlpDiVWrkSvxNUPHByXr/eEKqweIs0PLDi
         WrbcjyhZWNC531Gx/G8n18nV1OM/ds4CYokxk48czvFzdsgL30wAR1kFK2MBRiV7AM
         t+Z/F3MwWiUk7Gy6343lg4E3r/uUj6nWIyhhGcbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0888/1157] usb: cdns3: Dont use priv_dev uninitialized in cdns3_gadget_ep_enable()
Date:   Mon, 15 Aug 2022 20:04:04 +0200
Message-Id: <20220815180514.971498581@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 78acd4ca433425e6dd4032cfc2156c60e34931f2 ]

Clang warns:

  drivers/usb/cdns3/cdns3-gadget.c:2290:11: error: variable 'priv_dev' is uninitialized when used here [-Werror,-Wuninitialized]
                  dev_dbg(priv_dev->dev, "usbss: invalid parameters\n");
                          ^~~~~~~~
  include/linux/dev_printk.h:155:18: note: expanded from macro 'dev_dbg'
          dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
                          ^~~
  include/linux/dynamic_debug.h:167:7: note: expanded from macro 'dynamic_dev_dbg'
                          dev, fmt, ##__VA_ARGS__)
                          ^~~
  include/linux/dynamic_debug.h:152:56: note: expanded from macro '_dynamic_func_call'
          __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
  include/linux/dynamic_debug.h:134:15: note: expanded from macro '__dynamic_func_call'
                  func(&id, ##__VA_ARGS__);               \
                              ^~~~~~~~~~~
  drivers/usb/cdns3/cdns3-gadget.c:2278:31: note: initialize the variable 'priv_dev' to silence this warning
          struct cdns3_device *priv_dev;
                                      ^
                                      = NULL
  1 error generated.

The priv_dev assignment was moved below the if statement to avoid
potentially dereferencing ep before it was checked but priv_dev is used
in the dev_dbg() call.

To fix this, move the priv_dev and comp_desc assignments back to their
original spot and hoist the ep check above those assignments with a call
to pr_debug() instead of dev_dbg().

Fixes: c3ffc9c4ca44 ("usb: cdns3: change place of 'priv_ep' assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()")
Link: https://github.com/ClangBuiltLinux/linux/issues/1680
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdns3-gadget.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 1f38ccd637d0..87cfa91a758d 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2284,16 +2284,20 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
 	int ret = 0;
 	int val;
 
+	if (!ep) {
+		pr_debug("usbss: ep not configured?\n");
+		return -EINVAL;
+	}
+
 	priv_ep = ep_to_cdns3_ep(ep);
+	priv_dev = priv_ep->cdns3_dev;
+	comp_desc = priv_ep->endpoint.comp_desc;
 
-	if (!ep || !desc || desc->bDescriptorType != USB_DT_ENDPOINT) {
+	if (!desc || desc->bDescriptorType != USB_DT_ENDPOINT) {
 		dev_dbg(priv_dev->dev, "usbss: invalid parameters\n");
 		return -EINVAL;
 	}
 
-	comp_desc = priv_ep->endpoint.comp_desc;
-	priv_dev = priv_ep->cdns3_dev;
-
 	if (!desc->wMaxPacketSize) {
 		dev_err(priv_dev->dev, "usbss: missing wMaxPacketSize\n");
 		return -EINVAL;
-- 
2.35.1



