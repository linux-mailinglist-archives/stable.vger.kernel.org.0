Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6775C11DC22
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 03:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbfLMCbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 21:31:50 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34834 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfLMCbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 21:31:50 -0500
Received: by mail-pf1-f194.google.com with SMTP id b19so636663pfo.2;
        Thu, 12 Dec 2019 18:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VU8W+29VAE6jFbK7qOuEkNtChestID0TQVv19tl4TzA=;
        b=BsX91WyJ3Nk1wK5jIB4BZeo+UIaW3MvOPtwkDUqOsQ7lBFFvKxxAEngBlmSfQoZNLa
         5tTxwd2JMnKzYHwFt5RLW5YLKoKtPful9Qjbf56CnidI3ksFOI6obT2UrvLw1d1hI1nr
         w4AXDGo/hKt9EIswYATHIDAdg/2asKTWA5TMiaWYYW8Nd8Rwjq5alAj1ggM7TIMCK/+0
         TYSuNCnEnbad767SJtJTjEdwbmAffLWOozv+D93+zwhkdsDXf31KdF1HvesQ0o7o57Qo
         c9v5DGmWj3rURVqZwESr+6hDCSFDM5+73ZoZTSyaBHM49GcBVtZlS8LVMELxVR2wKIf3
         UKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VU8W+29VAE6jFbK7qOuEkNtChestID0TQVv19tl4TzA=;
        b=WpbBA7mrdLgp5w70+13p1XFDYB/s6VwsRxCcZYRYIWnzjKOoVj3X21gDBtFJDyxa57
         ReIabrjtKEKiO73iEoSXcK0XQcK2Mqz2v0gAF9JmKgBuHMV+r2qwhqvY/kFQDh6pORxd
         4PJLOH0XMecoqV9Ph6rLnBwW8u+siY/uUs+g1cRTYJO9i0qxLTlu0Quk6rsKsEJn1jHV
         QMZ9P0lI78J8sSB8BuUCFb0iNr+Nj99WUa6RQcPHdxm6PFX1LJC8gI6YMkbjBfK00JIO
         Eawx6gHVgKmIm5yNM2W4HBFMHplvY30KZbCECa8ihiOL3ZeNOok9Aj4tN/fqremF9oaD
         mP7Q==
X-Gm-Message-State: APjAAAX8+ME4kTYCRj27/NYNlFdrQtPqr9TFIhttC/KXykY6h8YZ2L96
        TMTkav/Fs7B6RRFR3L+kjGk=
X-Google-Smtp-Source: APXvYqyoiXE9viROKrRyaoUenVpkWigIxRGvBXQmBt4YZeDe6PYpB+c5VJh2QMBypaRwwP6UG/4r+g==
X-Received: by 2002:aa7:8007:: with SMTP id j7mr13594737pfi.73.1576204309272;
        Thu, 12 Dec 2019 18:31:49 -0800 (PST)
Received: from localhost.localdomain ([163.152.162.99])
        by smtp.gmail.com with ESMTPSA id h68sm9443654pfe.162.2019.12.12.18.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 18:31:48 -0800 (PST)
From:   Suwan Kim <suwan.kim027@gmail.com>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        Suwan Kim <suwan.kim027@gmail.com>
Subject: [PATCH v2 2/2] usbip: Fix error path of vhci_recv_ret_submit()
Date:   Fri, 13 Dec 2019 11:30:55 +0900
Message-Id: <20191213023055.19933-3-suwan.kim027@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213023055.19933-1-suwan.kim027@gmail.com>
References: <20191213023055.19933-1-suwan.kim027@gmail.com>
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

So, in the case of transaction error in vhci_recv_ret_submit(),
unlink URB from the endpoint, insert proper error code in
urb->status and give back URB.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
---
 drivers/usb/usbip/vhci_rx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index 33f8972ba842..00fc98741c5d 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
 
 	/* recv transfer buffer */
-	if (usbip_recv_xbuff(ud, urb) < 0)
-		return;
+	if (usbip_recv_xbuff(ud, urb) < 0) {
+		urb->status = -EPROTO;
+		goto error;
+	}
 
 	/* recv iso_packet_descriptor */
-	if (usbip_recv_iso(ud, urb) < 0)
-		return;
+	if (usbip_recv_iso(ud, urb) < 0) {
+		urb->status = -EPROTO;
+		goto error;
+	}
 
 	/* restore the padding in iso packets */
 	usbip_pad_iso(ud, urb);
 
+error:
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);
 
-- 
2.20.1

