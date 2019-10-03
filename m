Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D35CAB91
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfJCP4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730606AbfJCP4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:56:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3519D21848;
        Thu,  3 Oct 2019 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118188;
        bh=GlG6YVR+WVVS/QczyKCvj70xObEFrfnsuA3DId/ZobM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gf/U7xccfSyzg31sY44jczP2TbzlkOh4IOv5JRMV4zrIV1mANhWMSpCQvGptj08kh
         E4m9ywI5VLkt7FR4gLqeBw3nhjS75g9a+Y2ht+pGaiT8qSmAABFCvXmdsClORL355s
         Kh5tGMQPlUtkP2CEAlHrbdhFjXAbg8QqVPkrr9cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.4 21/99] cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize
Date:   Thu,  3 Oct 2019 17:52:44 +0200
Message-Id: <20191003154304.368107309@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 3fe4b3351301660653a2bc73f2226da0ebd2b95e ]

Endpoints with zero wMaxPacketSize are not usable for transferring
data. Ignore such endpoints when looking for valid in, out and
status pipes, to make the driver more robust against invalid and
meaningless descriptors.

The wMaxPacketSize of the out pipe is used as divisor. So this change
fixes a divide-by-zero bug.

Reported-by: syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -636,8 +636,12 @@ cdc_ncm_find_endpoints(struct usbnet *de
 	u8 ep;
 
 	for (ep = 0; ep < intf->cur_altsetting->desc.bNumEndpoints; ep++) {
-
 		e = intf->cur_altsetting->endpoint + ep;
+
+		/* ignore endpoints which cannot transfer data */
+		if (!usb_endpoint_maxp(&e->desc))
+			continue;
+
 		switch (e->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 		case USB_ENDPOINT_XFER_INT:
 			if (usb_endpoint_dir_in(&e->desc)) {


