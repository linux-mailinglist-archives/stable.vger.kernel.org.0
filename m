Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3786C226B25
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgGTQjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbgGTPsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:48:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54ACF22CBB;
        Mon, 20 Jul 2020 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260099;
        bh=wY5bv0DP0zB6LRwEhpa4mWwaj+UkoBIzhEit4/A/tTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwmcLoshkvN9OMesYwSgLDawwjXCU6lVj3IRuQr6s64L8CjE1onDnEFk3yeTjI4Ai
         EHj2SG4mTZnmc0hcXpbATHpgxnfumrMr0e0TP4tq14z58GkbdmFjmJkhXnZF1q+vk7
         uTf2c+IZE7AoED4ly/ri1FyG/ZI2dm1g8ClDsTQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Amit Shah <amit@kernel.org>
Subject: [PATCH 4.14 106/125] virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial
Date:   Mon, 20 Jul 2020 17:37:25 +0200
Message-Id: <20200720152808.141562416@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
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
@@ -2158,6 +2158,7 @@ static struct virtio_device_id id_table[
 	{ VIRTIO_ID_CONSOLE, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, id_table);
 
 static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
@@ -2170,6 +2171,7 @@ static struct virtio_device_id rproc_ser
 #endif
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(virtio, rproc_serial_id_table);
 
 static unsigned int rproc_serial_features[] = {
 };
@@ -2322,6 +2324,5 @@ static void __exit fini(void)
 module_init(init);
 module_exit(fini);
 
-MODULE_DEVICE_TABLE(virtio, id_table);
 MODULE_DESCRIPTION("Virtio console driver");
 MODULE_LICENSE("GPL");


