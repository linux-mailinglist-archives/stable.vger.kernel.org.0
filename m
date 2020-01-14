Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C832313A6A8
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbgANKMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:12:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733104AbgANKMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:12:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E89DF207FF;
        Tue, 14 Jan 2020 10:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996765;
        bh=y3hojQXEA8XV+d/pNvuWwQg0+T/RPwpbZaLgU7memec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0EtPfJSRN7mWsGIf3ZcxEcMEWkR0lybkoeTQ0oIhlSdwXdTFzO190ZZGN25+uZ/3
         I+aWlNmZ8f6661hlvrrlyZ2emQg5HmGQdmQ0/GLhlGIQ2gpXEgs1MOWZUUqUjnX/PG
         u5aY1qjc4pF8t9pWKvcRgizDaDZtI2byl9uFGaBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.4 08/28] HID: uhid: Fix returning EPOLLOUT from uhid_char_poll
Date:   Tue, 14 Jan 2020 11:02:10 +0100
Message-Id: <20200114094341.152658288@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
References: <20200114094336.845958665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

commit be54e7461ffdc5809b67d2aeefc1ddc9a91470c7 upstream.

Always return EPOLLOUT from uhid_char_poll to allow polling /dev/uhid
for writable state.

Fixes: 1f9dec1e0164 ("HID: uhid: allow poll()'ing on uhid devices")
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/uhid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -26,6 +26,7 @@
 #include <linux/uhid.h>
 #include <linux/wait.h>
 #include <linux/uaccess.h>
+#include <linux/eventpoll.h>
 
 #define UHID_NAME	"uhid"
 #define UHID_BUFSIZE	32
@@ -774,7 +775,7 @@ static unsigned int uhid_char_poll(struc
 	if (uhid->head != uhid->tail)
 		return POLLIN | POLLRDNORM;
 
-	return 0;
+	return EPOLLOUT | EPOLLWRNORM;
 }
 
 static const struct file_operations uhid_fops = {


