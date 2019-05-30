Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C35A2EC3E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbfE3DTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731878AbfE3DTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:24 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C818B2484B;
        Thu, 30 May 2019 03:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186363;
        bh=J4uwusvLtrICANSHTWdP5KgOtyuG4ox8q63z/IbzCHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZosiTMfQJZb1lK5qEQCeOi5gqunvpIxEjEygWJjcmCc9jUGoGZjseTTao/rgnzVG
         NekBs778vAZUk/QaAG9lnqbxm2CHSE0OyiFSBhQq5x3jy/NH5hkRjxSzMadQUzkGuA
         Uzb4oqyf0kX7vIMoIyrkHQbWcqQ/CRzN00Su+TMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 111/193] hwmon: (vt1211) Use request_muxed_region for Super-IO accesses
Date:   Wed, 29 May 2019 20:06:05 -0700
Message-Id: <20190530030504.249468936@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 14b97ba5c20056102b3dd22696bf17b057e60976 ]

Super-IO accesses may fail on a system with no or unmapped LPC bus.

Also, other drivers may attempt to access the LPC bus at the same time,
resulting in undefined behavior.

Use request_muxed_region() to ensure that IO access on the requested
address space is supported, and to ensure that access by multiple drivers
is synchronized.

Fixes: 2219cd81a6cd ("hwmon/vt1211: Add probing of alternate config index port")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/vt1211.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index 3a6bfa51cb94f..95d5e8ec8b7fc 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -226,15 +226,21 @@ static inline void superio_select(int sio_cip, int ldn)
 	outb(ldn, sio_cip + 1);
 }
 
-static inline void superio_enter(int sio_cip)
+static inline int superio_enter(int sio_cip)
 {
+	if (!request_muxed_region(sio_cip, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x87, sio_cip);
 	outb(0x87, sio_cip);
+
+	return 0;
 }
 
 static inline void superio_exit(int sio_cip)
 {
 	outb(0xaa, sio_cip);
+	release_region(sio_cip, 2);
 }
 
 /* ---------------------------------------------------------------------
@@ -1282,11 +1288,14 @@ static int __init vt1211_device_add(unsigned short address)
 
 static int __init vt1211_find(int sio_cip, unsigned short *address)
 {
-	int err = -ENODEV;
+	int err;
 	int devid;
 
-	superio_enter(sio_cip);
+	err = superio_enter(sio_cip);
+	if (err)
+		return err;
 
+	err = -ENODEV;
 	devid = force_id ? force_id : superio_inb(sio_cip, SIO_VT1211_DEVID);
 	if (devid != SIO_VT1211_ID)
 		goto EXIT;
-- 
2.20.1



