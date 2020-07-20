Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD11C226C2F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgGTPjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgGTPjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E7FD22D2C;
        Mon, 20 Jul 2020 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259548;
        bh=txuOplGWjmQ3K1s8FW4oD57jL9HKZnOuWKFfbWDy9uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXVZz17OXZlEJpn1atAkmSKlWtHtj4PLlF9EUarPAneUA/Nj+NUXoNyR7cUAt8t8P
         K3y1dSaWOfZ83bwWysHquUfADLj74wU3aGz3slG9RcJWhOcUcLpXnZDonqvyas4oYM
         o4u8t1Jsf+KIZFUZHo5rx2gqRpltpFWCTX46E6NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Amit Shah <amit@kernel.org>
Subject: [PATCH 4.4 49/58] virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial
Date:   Mon, 20 Jul 2020 17:37:05 +0200
Message-Id: <20200720152749.693616676@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

commit 897c44f0bae574c5fb318c759b060bebf9dd6013 upstream.

rproc_serial_id_table lacks an exposure to module devicetable, so
when remoteproc firmware requests VIRTIO_ID_RPROC_SERIAL, no uevent
is generated and no module autoloading occurs.
Add missing MODULE_DEVICE_TABLE() annotation and move the existing
one for VIRTIO_ID_CONSOLE right to the table itself.

Fixes: 1b6370463e88 ("virtio_console: Add support for remoteproc serial")
Cc: <stable@vger.kernel.org> # v3.8+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Amit Shah <amit@kernel.org>
Link: https://lore.kernel.org/r/x7C_CbeJtoGMy258nwAXASYz3xgFMFpyzmUvOyZzRnQrgWCREBjaqBOpAUS7ol4NnZYvSVwmTsCG0Ohyfvta-ygw6HMHcoeKK0C3QFiAO_Q=@pm.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/virtio_console.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2155,6 +2155,7 @@ static struct virtio_device_id id_table[
 	{ VIRTIO_ID_CONSOLE, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, id_table);
 
 static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
@@ -2167,6 +2168,7 @@ static struct virtio_device_id rproc_ser
 #endif
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, rproc_serial_id_table);
 
 static unsigned int rproc_serial_features[] = {
 };
@@ -2319,6 +2321,5 @@ static void __exit fini(void)
 module_init(init);
 module_exit(fini);
 
-MODULE_DEVICE_TABLE(virtio, id_table);
 MODULE_DESCRIPTION("Virtio console driver");
 MODULE_LICENSE("GPL");


