Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB746D855D
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbjDERzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjDERzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:55:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F23E7287
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 10:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BFC0628B5
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 17:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336F3C4339B;
        Wed,  5 Apr 2023 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680717330;
        bh=jCclfxlpbPmIoF9LWCjXOR0LvyEJfFfivJwlaaJNfUE=;
        h=Subject:To:From:Date:From;
        b=Dn9oWE5fv1tD528gASo5fOJpqg+HXNnMjxRfnFG6a5TqbBN3afzUWElKJIBOEIabk
         RxiS9DmaS6kykuHAuuvsb40F3Q5caIb80uDyzoPXplPZGh4Ycnaflb0cCZh7Tbx+XD
         4peKHq1E0uvP9wRzYPilsTDJU+Yhr4IhLsfZVgj0=
Subject: patch "usb: cdnsp: Fixes error: uninitialized symbol 'len'" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 05 Apr 2023 19:55:27 +0200
Message-ID: <2023040527-tableware-frozen-59e5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fixes error: uninitialized symbol 'len'

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1edf48991a783d00a3a18dc0d27c88139e4030a2 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Fri, 31 Mar 2023 05:06:00 -0400
Subject: usb: cdnsp: Fixes error: uninitialized symbol 'len'

The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant
Status Stage" leads to the following Smatch static checker warning:

  drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
  error: uninitialized symbol 'len'.

cc: <stable@vger.kernel.org>
Fixes: 5bc38d33a5a1 ("usb: cdnsp: Fixes issue with redundant Status Stage")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230331090600.454674-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ep0.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index d63d5d92f255..f317d3c84781 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -414,7 +414,7 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
-	int ret = 0;
+	int ret = -EINVAL;
 	u16 len;
 
 	trace_cdnsp_ctrl_req(ctrl);
@@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 
 	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
 		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
-		ret = -EINVAL;
 		goto out;
 	}
 
-- 
2.40.0


