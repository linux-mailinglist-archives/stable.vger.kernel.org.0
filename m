Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7131611C574
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 06:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLLF3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 00:29:41 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:42941 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLLF3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 00:29:41 -0500
Received: by mail-pj1-f66.google.com with SMTP id o11so523573pjp.9;
        Wed, 11 Dec 2019 21:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ty3dpK0QTIzeB9iEDR4WAHT8NL5h1eWqIJaiU5glr4w=;
        b=MvOxXaJJ2IDFyzGFq4UInxj47QiscDaLhYt7M0EP5WBcwN2+3/NiArepmzNC4+A0Sv
         Ll30HqN8p4r33J3HTR2uWW2lT9Z2f9JsIsmyPo8d1Be9fAmy9PpkmO3I+IH/AyDdF5b3
         h0zei4D2vTlnmmZZSquKtLEnRc5oL9T/DvDxVazJgApCejDPRm6ey8/dfOsq5PdWuVXU
         fkrCH2gqmiH17vyTDRZfRW9s2y8QXJUjSA8VSe8iNc63vDe6KLTiA68cTe6mfV3411iA
         /GzJ3je9Nu7ftlLJUBZDuiPbrGtsYbQxEP1x2z+GgghBOoIlO/6v2fBLsshmsIMX9Yd1
         EgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ty3dpK0QTIzeB9iEDR4WAHT8NL5h1eWqIJaiU5glr4w=;
        b=WJiigQUQ4c4ZClztagmHP/yOox9b69KDr81tDh1Lom6GtqjrZ6GqrnI6bxmNZuVQvg
         jHeGRxda1r/aTFVmRFMzOhdh2Iho20qOgTvcQI+ok6r9LTKUzvXKGTS3nkk9qga7LvP6
         RxYOcq1k3Vlpa0tbLDtaHxNynJ2PrNwV3EGDPiec+v87QJW+qSxBoyTfkAHNL4fUgCzD
         2gNIg4tErWBuin2rlKfHwCav2saALY5Qp5lI1JqN6y1PYJmqkFbqaiMrtXWbPvi8ovRQ
         8C/tLExNZzcV5vMbMtKdtU4GaZUr5hhtcDHSLx3b9b0UadksgS7VvOjnd85LaHgVEIjg
         +4yA==
X-Gm-Message-State: APjAAAWsYx+WHieKcqxFhletZMEX3BmH7I7OdBxf1sq9dSdyu/66MyMh
        WwhqjISgYWhpfPis+Dvm9aPJMLNR
X-Google-Smtp-Source: APXvYqw67g9FGJ3Vsm4Tg5w1zgdJ1orF+ZDvuJ6G4/7V8u/UUhkJNsMtkHC/XUA8SoL+1XPJKIaX5A==
X-Received: by 2002:a17:90a:33e8:: with SMTP id n95mr7975895pjb.17.1576128580674;
        Wed, 11 Dec 2019 21:29:40 -0800 (PST)
Received: from localhost.localdomain ([163.152.162.99])
        by smtp.gmail.com with ESMTPSA id h7sm5532289pfq.36.2019.12.11.21.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 21:29:40 -0800 (PST)
From:   Suwan Kim <suwan.kim027@gmail.com>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Suwan Kim <suwan.kim027@gmail.com>
Subject: [PATCH 2/2] usbip: Fix error path of vhci_recv_ret_submit()
Date:   Thu, 12 Dec 2019 14:28:41 +0900
Message-Id: <20191212052841.6734-3-suwan.kim027@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212052841.6734-1-suwan.kim027@gmail.com>
References: <20191212052841.6734-1-suwan.kim027@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a transaction error happens in vhci_recv_ret_submit(), event
handler closes connection and changes port status to kick hub_event.
Then hub tries to flush the endpoint URBs, but that causes infinite
loop between usb_hub_flush_endpoint() and vhci_urb_dequeue() because
"vhci_priv" in vhci_urb_dequeue() was already released by
vhci_recv_ret_submit() before a transmission error occurred. Thus,
vhci_urb_dequeue() terminates early and usb_hub_flush_endpoint()
continuously calls vhci_urb_dequeue().

The root cause of this issue is that vhci_recv_ret_submit()
terminates early without giving back URB when transaction error
occurs in vhci_recv_ret_submit(). That causes the error URB to still
be linked at endpoint list without “vhci_priv".

So, in the case of trasnaction error in vhci_recv_ret_submit(),
unlink URB from the endpoint, insert proper error code in
urb->status and give back URB.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
---
 drivers/usb/usbip/vhci_rx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index 33f8972ba842..dc26acad6baf 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
 
 	/* recv transfer buffer */
-	if (usbip_recv_xbuff(ud, urb) < 0)
-		return;
+	if (usbip_recv_xbuff(ud, urb) < 0) {
+		urb->status = -EPIPE;
+		goto error;
+	}
 
 	/* recv iso_packet_descriptor */
-	if (usbip_recv_iso(ud, urb) < 0)
-		return;
+	if (usbip_recv_iso(ud, urb) < 0) {
+		urb->status = -EPIPE;
+		goto error;
+	}
 
 	/* restore the padding in iso packets */
 	usbip_pad_iso(ud, urb);
 
+error:
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);
 
-- 
2.20.1

