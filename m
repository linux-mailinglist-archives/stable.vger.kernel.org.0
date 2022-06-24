Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB455598C1
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 13:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiFXLpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 07:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiFXLpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 07:45:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFD9517F7
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 04:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E5CB82805
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 11:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A96C34114;
        Fri, 24 Jun 2022 11:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656071143;
        bh=0gUHkp9JD2LD37UyiIFEe6mxKgSrJKMC5LSc4KV2f8Y=;
        h=Subject:To:From:Date:From;
        b=aBD8JuGt4Rp5LtLpWj5LKQOpYe87CuU8up2Nks1fQazmvVS7ugeZcEznSja1aZzb+
         K6dkOzoZOEO68hY5GKfDHe0NMb2hGZUGaNPork6BdOEwZnAGZifrcav5G9PNsIX6Py
         pkGugJZ70Jzqz898hFhzcadUhCGjEwxW88ZA7vv0=
Subject: patch "usb: chipidea: udc: check request status before setting device" added to usb-linus
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Jun 2022 13:45:33 +0200
Message-ID: <1656071133126238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: udc: check request status before setting device

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b24346a240b36cfc4df194d145463874985aa29b Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Thu, 23 Jun 2022 11:02:42 +0800
Subject: usb: chipidea: udc: check request status before setting device
 address

The complete() function may be called even though request is not
completed. In this case, it's necessary to check request status so
as not to set device address wrongly.

Fixes: 10775eb17bee ("usb: chipidea: udc: update gadget states according to ch9")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20220623030242.41796-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/udc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index dc6c96e04bcf..3b8bf6daf7d0 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1048,6 +1048,9 @@ isr_setup_status_complete(struct usb_ep *ep, struct usb_request *req)
 	struct ci_hdrc *ci = req->context;
 	unsigned long flags;
 
+	if (req->status < 0)
+		return;
+
 	if (ci->setaddr) {
 		hw_usb_set_address(ci, ci->address);
 		ci->setaddr = false;
-- 
2.36.1


