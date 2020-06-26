Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87D020B44A
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 17:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgFZPRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 11:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFZPRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 11:17:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F5D420702;
        Fri, 26 Jun 2020 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593184637;
        bh=bEopOCfcNqXNfyGY8+wJ7TK9H355h5wkAUtFffA7EoE=;
        h=Subject:To:From:Date:From;
        b=EoUQjZusc9Cdo7jutlxJ2U9jfBdbC7f6HTo9qDv4ltE9Vb3qywWqQUEJFmvOp9FiE
         a8+K0AmJDF3L85yev4Stl5jyv35lPfJtM6begItr0FcGjM6FSp1hY1tom+FLzecLDV
         ZNT5q3F7wli03efrOtzZKcPNv1DrCC/EdMTtGwiI=
Subject: patch "usb: cdns3: ep0: fix the test mode set incorrectly" added to usb-linus
To:     peter.chen@nxp.com, balbi@kernel.org, jun.li@nxp.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jun 2020 17:17:12 +0200
Message-ID: <15931846325388@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: ep0: fix the test mode set incorrectly

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b51e1cf64f93acebb6d8afbacd648a6ecefc39b4 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Tue, 23 Jun 2020 11:09:16 +0800
Subject: usb: cdns3: ep0: fix the test mode set incorrectly

The 'tmode' is ctrl->wIndex, changing it as the real test
mode value for register assignment.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/cdns3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index 82645a2a0f52..04e49582fb55 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -327,7 +327,8 @@ static int cdns3_ep0_feature_handle_device(struct cdns3_device *priv_dev,
 		if (!set || (tmode & 0xff) != 0)
 			return -EINVAL;
 
-		switch (tmode >> 8) {
+		tmode >>= 8;
+		switch (tmode) {
 		case TEST_J:
 		case TEST_K:
 		case TEST_SE0_NAK:
-- 
2.27.0


