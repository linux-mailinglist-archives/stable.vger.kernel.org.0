Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E215E12C556
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfL2Rfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbfL2Rfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ADBB207FD;
        Sun, 29 Dec 2019 17:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640929;
        bh=9+QBl7TrOgrI8z1wzHDeCsLc+etCg3O/tjMsm2XPdbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/UBDAAbO0YUIMidBEZlZiOBlwZVehz3jEJbIUxV5fTque99JC9m5x1Lop4u3y/o8
         HlbcIlHu3OSyKGb2T8hPJxbseWjRu1RFAz5Jt/PCQ+E+QWvohPb6d8gYolKKddx9/T
         d5mKUvwxnXWSC45JgW86JGLrqGDZJXtpZ0orL064=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Suwan Kim <suwan.kim027@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 197/219] usbip: Fix receive error in vhci-hcd when using scatter-gather
Date:   Sun, 29 Dec 2019 18:19:59 +0100
Message-Id: <20191229162539.623519867@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suwan Kim <suwan.kim027@gmail.com>

commit d986294ee55d719562b20aabe15a39bf8f863415 upstream.

When vhci uses SG and receives data whose size is smaller than SG
buffer size, it tries to receive more data even if it acutally
receives all the data from the server. If then, it erroneously adds
error event and triggers connection shutdown.

vhci-hcd should check if it received all the data even if there are
more SG entries left. So, check if it receivces all the data from
the server in for_each_sg() loop.

Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213023055.19933-2-suwan.kim027@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/usbip_common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -727,6 +727,9 @@ int usbip_recv_xbuff(struct usbip_device
 
 			copy -= recv;
 			ret += recv;
+
+			if (!copy)
+				break;
 		}
 
 		if (ret != size)


