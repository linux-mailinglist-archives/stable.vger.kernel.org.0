Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9461617F5A4
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgCJLGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:06:17 -0400
Received: from fd.dlink.ru ([178.170.168.18]:41560 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgCJLGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 07:06:16 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 0BB0A1B202D6; Tue, 10 Mar 2020 14:06:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 0BB0A1B202D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1583838373; bh=zWQ6sSBeQ4ZJmFi46qXc72fj+12rlHW/EzyjYyoS410=;
        h=From:To:Cc:Subject:Date;
        b=bBwaJaBmKlfSV9U6fVwNkddD6Xi/28pLcXBpD/PHpl/Kzqt4zMusfCEbAdG59Nx0Q
         aYBT0i09rzwC2u617ClWAYCsAdspDzMhQAToFDt9yUUebxFrzMjXbmY6xPAkcaFQZl
         L8ESg3u3lbzU8XePe7RpJVAGcmrz7qkXOvGdv4nU=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id E84601B202D2;
        Tue, 10 Mar 2020 14:06:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru E84601B202D2
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id C2C611B20AE9;
        Tue, 10 Mar 2020 14:06:04 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Tue, 10 Mar 2020 14:06:04 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Amit Shah <amit@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sjur Brandeland <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alexander Lobakin <alobakin@dlink.ru>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial
Date:   Tue, 10 Mar 2020 14:05:38 +0300
Message-Id: <20200310110538.19254-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

rproc_serial_id_table lacks an exposure to module devicetable, so
when remoteproc firmware requests VIRTIO_ID_RPROC_SERIAL, no uevent
is generated and no module autoloading occurs.
Add missing MODULE_DEVICE_TABLE() annotation and move the existing
one for VIRTIO_ID_CONSOLE right to the table itself.

Fixes: 1b6370463e88 ("virtio_console: Add support for remoteproc serial")
Cc: <stable@vger.kernel.org> # v3.8+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 drivers/char/virtio_console.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 4df9b40d6342..7e1bc0f580a2 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2116,6 +2116,7 @@ static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_CONSOLE, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, id_table);
 
 static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
@@ -2128,6 +2129,7 @@ static struct virtio_device_id rproc_serial_id_table[] = {
 #endif
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, rproc_serial_id_table);
 
 static unsigned int rproc_serial_features[] = {
 };
@@ -2280,6 +2282,5 @@ static void __exit fini(void)
 module_init(init);
 module_exit(fini);
 
-MODULE_DEVICE_TABLE(virtio, id_table);
 MODULE_DESCRIPTION("Virtio console driver");
 MODULE_LICENSE("GPL");
-- 
2.25.1

