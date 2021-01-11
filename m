Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABCC2F147D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbhAKNZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732549AbhAKNRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1852255F;
        Mon, 11 Jan 2021 13:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371011;
        bh=O51D1ZDFgkJIl06u/ZM5IP4821yUgiZrKrBk77agCpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZVqEroplCqDEaBLvN5rc4t8X0ke9I/wI98j38EY/PIfhPji1lUJFfO8Vy3EEOzSE
         +1ZXxlSKM1Pbk0vqLFgs58RMvm5lrFPHJJoc5MzdUn3xhViIXZghE+u7PhT5dIO2Lj
         3rpMsWyNqlgF7K7oHgWpHoaNMijrmv6SsF4wJtcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.10 103/145] USB: gadget: legacy: fix return error code in acm_ms_bind()
Date:   Mon, 11 Jan 2021 14:02:07 +0100
Message-Id: <20210111130053.476972842@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit c91d3a6bcaa031f551ba29a496a8027b31289464 upstream.

If usb_otg_descriptor_alloc() failed, it need return ENOMEM.

Fixes: 578aa8a2b12c ("usb: gadget: acm_ms: allocate and init otg descriptor by otg capabilities")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201117092955.4102785-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/legacy/acm_ms.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/acm_ms.c
+++ b/drivers/usb/gadget/legacy/acm_ms.c
@@ -200,8 +200,10 @@ static int acm_ms_bind(struct usb_compos
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail_string_ids;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;


