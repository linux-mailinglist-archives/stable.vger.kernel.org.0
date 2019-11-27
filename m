Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD4210BADB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfK0VHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732568AbfK0VHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AFD5217D6;
        Wed, 27 Nov 2019 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888832;
        bh=aJqLwpf/G8NqfB0sL2MWBrc35kuUJFRONfEAYaqxE9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbau14lcPSfR25RI4CwdoWsZRL0LloII3/VVyViadOahXMg0xGBgwll2NE9j8vbU7
         q+LiU8mVDzio4vcU2gSUp/tJAWjkNiivVi1agIQsVSFmeCln+2Vh2ybrU6kdNdpPPl
         AIxBMmrFsVevb6XiPtStWRR2yvDnLd0gzodmZFAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d93dff37e6a89431c158@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.19 288/306] media: b2c2-flexcop-usb: add sanity checking
Date:   Wed, 27 Nov 2019 21:32:18 +0100
Message-Id: <20191127203135.815814577@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 1b976fc6d684e3282914cdbe7a8d68fdce19095c upstream.

The driver needs an isochronous endpoint to be present. It will
oops in its absence. Add checking for it.

Reported-by: syzbot+d93dff37e6a89431c158@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/b2c2/flexcop-usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -537,6 +537,9 @@ static int flexcop_usb_probe(struct usb_
 	struct flexcop_device *fc = NULL;
 	int ret;
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	if ((fc = flexcop_device_kmalloc(sizeof(struct flexcop_usb))) == NULL) {
 		err("out of memory\n");
 		return -ENOMEM;


