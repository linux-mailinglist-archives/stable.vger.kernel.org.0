Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A197238086F
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 13:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhENL1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 07:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENL1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 07:27:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53E9D613DE;
        Fri, 14 May 2021 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620991586;
        bh=B7f4zc3Fy/PRFIS4G6CMkX4YSuq0TaUHB4j9EUUsjE8=;
        h=Subject:To:From:Date:From;
        b=IZP+eDNgMslddS7fp9x0wLarDYaMW75cNKHuduj6hBhS9OlmJQFgzTZgtGQf08p4b
         W3dr7oGrmEzYbdjDIhxOEFXIL0N0D1BCCgz00qOInHHyh7jAlAVjxZoZ34OojRMgDN
         /Q5W58C5D/FAtBBM3s4XIQ7RxCUWydI9T0SYA+pc=
Subject: patch "uio_hv_generic: Fix another memory leak in error handling paths" added to char-misc-linus
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 13:26:13 +0200
Message-ID: <162099157324747@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    uio_hv_generic: Fix another memory leak in error handling paths

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0b0226be3a52dadd965644bc52a807961c2c26df Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 9 May 2021 09:13:12 +0200
Subject: uio_hv_generic: Fix another memory leak in error handling paths

Memory allocated by 'vmbus_alloc_ring()' at the beginning of the probe
function is never freed in the error handling path.

Add the missing 'vmbus_free_ring()' call.

Note that it is already freed in the .remove function.

Fixes: cdfa835c6e5e ("uio_hv_generic: defer opening vmbus until first use")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0d86027b8eeed8e6360bc3d52bcdb328ff9bdca1.1620544055.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index eebc399f2cc7..652fe2547587 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -291,7 +291,7 @@ hv_uio_probe(struct hv_device *dev,
 	pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);
 	if (pdata->recv_buf == NULL) {
 		ret = -ENOMEM;
-		goto fail_close;
+		goto fail_free_ring;
 	}
 
 	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
@@ -351,6 +351,8 @@ hv_uio_probe(struct hv_device *dev,
 
 fail_close:
 	hv_uio_cleanup(dev, pdata);
+fail_free_ring:
+	vmbus_free_ring(dev->channel);
 
 	return ret;
 }
-- 
2.31.1


