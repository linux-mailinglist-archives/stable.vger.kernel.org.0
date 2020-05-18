Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61F91D8222
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgERRxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731173AbgERRxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:53:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A8CE207C4;
        Mon, 18 May 2020 17:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824418;
        bh=bDJ1mgZU+h5ToiLcvLdkwXTROH+5BR7TJ+0MyXthK4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtmzQk6t6QyK3krBYCiiVE68wECaRlIE/a5IFSiuL9FfSU9JsHthh1TQelaGI4Da3
         aBxnYPBR/+BUAWqu2Q26d3LC/2BQtN/IRE1TQbdCuUEsnSHF7mPZdL9dCXuZUH5him
         1Vbq+gwC7uVgweDGc6E92m3iryVQCB4XwNSPpq7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 69/80] usb: gadget: audio: Fix a missing error return value in audio_bind()
Date:   Mon, 18 May 2020 19:37:27 +0200
Message-Id: <20200518173504.266735216@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 19b94c1f9c9a16d41a8de3ccbdb8536cf1aecdbf upstream.

If 'usb_otg_descriptor_alloc()' fails, we must return an error code, not 0.

Fixes: 56023ce0fd70 ("usb: gadget: audio: allocate and init otg descriptor by otg capabilities")
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/legacy/audio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/audio.c
+++ b/drivers/usb/gadget/legacy/audio.c
@@ -300,8 +300,10 @@ static int audio_bind(struct usb_composi
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(cdev->gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail;
+		}
 		usb_otg_descriptor_init(cdev->gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;


