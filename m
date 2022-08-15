Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151915939A8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243625AbiHOT2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344813AbiHOT1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:27:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC07A5B04C;
        Mon, 15 Aug 2022 11:43:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 925B7B8105D;
        Mon, 15 Aug 2022 18:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5584C433D6;
        Mon, 15 Aug 2022 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588983;
        bh=TyFNt0yGMX+HCgNReElfeOZCISJv3dIiyMGCwZjmTq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ri+4kvwWsP1HDeZRpxFypFNc4xQKyKSXVnc31F6v2jFPJH5+VTFs1aoTWmbudTYae
         uRZnnaqdud1qBrGKRkQcHpkbcfHQqW+jFCTUwzXJN66PMrNaJqVg5tiGs2vXAiqHsV
         TVXemb/6h/xBgbz6aSGF9sgJReaNGMKjJkD7tl/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 559/779] usb: cdns3: Dont use priv_dev uninitialized in cdns3_gadget_ep_enable()
Date:   Mon, 15 Aug 2022 20:03:23 +0200
Message-Id: <20220815180401.230200387@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index e0cf62e65075..ae049eb28b93 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2280,16 +2280,20 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
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



