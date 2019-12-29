Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F072012C8A8
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733116AbfL2R4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733131AbfL2R4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A087222C4;
        Sun, 29 Dec 2019 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642211;
        bh=9+QBl7TrOgrI8z1wzHDeCsLc+etCg3O/tjMsm2XPdbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=javd6JytPKfDtnMrXzpvtl5/j3U1luHzPItYYbrePA3W20jlA1BsAZOKgMk04UD0U
         C4470RPd8rXpJMr8Ew3qI9eJwp8y1DpL+oG6B2eWcY8Q2xm2af2iwpFReZyEU+iCmb
         gFzgpL1lepXrqkT1D2LwH4A9fI5Lv1JlfgpuILaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Suwan Kim <suwan.kim027@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 389/434] usbip: Fix receive error in vhci-hcd when using scatter-gather
Date:   Sun, 29 Dec 2019 18:27:22 +0100
Message-Id: <20191229172728.095110722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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


