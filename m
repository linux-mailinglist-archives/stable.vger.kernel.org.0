Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3901199B83
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404389AbfHVRZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404376AbfHVRZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:20 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC64F2064A;
        Thu, 22 Aug 2019 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494719;
        bh=sihiTipHc8/WKfVhvkAVkcyT3aK0UieUNF3eUbU5xMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miEsIWqVoUi+zmG7J2ZDcXJgQE47voPLiLAsHUlq2pj3Pf4MqduXicF5GPxESOeGa
         DdTU7InFy3GiYZ+ujvFZo62gp5rbSZd0dSBF+mwGNvHhQ+81ixxqCN9zPjZFenVvIo
         nhhPUeeBPX2wBtHlBrsmMyyxfDPUTUbyBs3qeB2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+45a53506b65321c1fe91@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 49/71] USB: CDC: fix sanity checks in CDC union parser
Date:   Thu, 22 Aug 2019 10:19:24 -0700
Message-Id: <20190822171729.971517249@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 54364278fb3cabdea51d6398b07c87415065b3fc upstream.

A few checks checked for the size of the pointer to a structure
instead of the structure itself. Copy & paste issue presumably.

Fixes: e4c6fb7794982 ("usbnet: move the CDC parser into USB core")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+45a53506b65321c1fe91@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190813093541.18889-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/message.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2143,14 +2143,14 @@ int cdc_parse_cdc_header(struct usb_cdc_
 				(struct usb_cdc_dmm_desc *)buffer;
 			break;
 		case USB_CDC_MDLM_TYPE:
-			if (elength < sizeof(struct usb_cdc_mdlm_desc *))
+			if (elength < sizeof(struct usb_cdc_mdlm_desc))
 				goto next_desc;
 			if (desc)
 				return -EINVAL;
 			desc = (struct usb_cdc_mdlm_desc *)buffer;
 			break;
 		case USB_CDC_MDLM_DETAIL_TYPE:
-			if (elength < sizeof(struct usb_cdc_mdlm_detail_desc *))
+			if (elength < sizeof(struct usb_cdc_mdlm_detail_desc))
 				goto next_desc;
 			if (detail)
 				return -EINVAL;


