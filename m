Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34A136FC33
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhD3OWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233278AbhD3OV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20628613A9;
        Fri, 30 Apr 2021 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792471;
        bh=zpIW2u9iH5OdC5H6HFelvBfnbS5UkEcsuLSmrlKJ6oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvKTLv3mk+oNpdxwL9sS00MV5l2mNV3dFNusAtTFio4HfxLqGf4ApPJ4AsUr92jho
         9j4Rj59XF/AWo+27jQv6a83UO2kxgPVLy2ntxCcAtzKyCfQIF3XYhypV3uKiQ89ddS
         brONsUAYUXN/01aoUMbFSvFaAMRqF9s6o4rBaRBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anirudh Rayabharam <mail@anirudhrb.com>,
        Leonardo Antoniazzi <leoanto@aruba.it>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 1/5] net: hso: fix NULL-deref on disconnect regression
Date:   Fri, 30 Apr 2021 16:20:56 +0200
Message-Id: <20210430141910.945061629@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141910.899518186@linuxfoundation.org>
References: <20210430141910.899518186@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2ad5692db72874f02b9ad551d26345437ea4f7f3 upstream.

Commit 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device
unregistration") fixed the racy minor allocation reported by syzbot, but
introduced an unconditional NULL-pointer dereference on every disconnect
instead.

Specifically, the serial device table must no longer be accessed after
the minor has been released by hso_serial_tty_unregister().

Fixes: 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device unregistration")
Cc: stable@vger.kernel.org
Cc: Anirudh Rayabharam <mail@anirudhrb.com>
Reported-by: Leonardo Antoniazzi <leoanto@aruba.it>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -3104,7 +3104,7 @@ static void hso_free_interface(struct us
 			cancel_work_sync(&serial_table[i]->async_put_intf);
 			cancel_work_sync(&serial_table[i]->async_get_intf);
 			hso_serial_tty_unregister(serial);
-			kref_put(&serial_table[i]->ref, hso_serial_ref_free);
+			kref_put(&serial->parent->ref, hso_serial_ref_free);
 		}
 	}
 


