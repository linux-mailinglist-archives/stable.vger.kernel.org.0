Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB2313711
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhBHPTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:19:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233475AbhBHPNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C45AF64EB6;
        Mon,  8 Feb 2021 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796995;
        bh=P5FszMvcTGEB9zp098oA/xcLefOaRom4Iw25ecRU/DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkhIgYZN3A+u/W/4ImxJdJMi3WQfMGVnLWBNOR/r838hnB/o0EJPgGYBvjjOa96Lb
         RxjulEckblQBrhy8NiKQE+tLUqbGUnaQ+I3ITU2j8WCNUKlLzYkhkYKbMuMB2FTLGf
         ykw18SHtMxE1F47R1V/parlTsbRqOfo5JXJdZ9Gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.4 23/65] USB: gadget: legacy: fix an error code in eth_bind()
Date:   Mon,  8 Feb 2021 16:00:55 +0100
Message-Id: <20210208145811.139112091@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3e1f4a2e1184ae6ad7f4caf682ced9554141a0f4 upstream.

This code should return -ENOMEM if the allocation fails but it currently
returns success.

Fixes: 9b95236eebdb ("usb: gadget: ether: allocate and init otg descriptor by otg capabilities")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YBKE9rqVuJEOUWpW@mwanda
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/ether.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/ether.c
+++ b/drivers/usb/gadget/legacy/ether.c
@@ -403,8 +403,10 @@ static int eth_bind(struct usb_composite
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail1;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;


