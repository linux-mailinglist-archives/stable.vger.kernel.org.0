Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3C171923
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgB0NmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729739AbgB0NmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:42:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE75C21D7E;
        Thu, 27 Feb 2020 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810933;
        bh=AHEsC+E3W2xJQbzUvuMY92P8qdh5Jea/uQfL/fYkVJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5ef+Det/fpy9EB+K2Hf307uPw4LQLIQMLuNmUZpEobRL6Of9V9f4ObhcfKxVCedh
         GWxePoc+s2QRY/AlVIqH0uUCYCVNK/hVDsst5eK5sF3moSSKFTsjLBDgvTlYMUmon4
         tN11la7XwwkgKUO91bFvBu0VdlJIgn098753C7GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 052/113] usbip: Fix unsafe unaligned pointer usage
Date:   Thu, 27 Feb 2020 14:36:08 +0100
Message-Id: <20200227132220.080009840@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 585c91f40d201bc564d4e76b83c05b3b5363fe7e ]

Fix unsafe unaligned pointer usage in usbip network interfaces. usbip tool
build fails with new gcc -Werror=address-of-packed-member checks.

usbip_network.c: In function ‘usbip_net_pack_usb_device’:
usbip_network.c:79:32: error: taking address of packed member of ‘struct usbip_usb_device’ may result in an unaligned pointer value [-Werror=address-of-packed-member]
   79 |  usbip_net_pack_uint32_t(pack, &udev->busnum);

Fix with minor changes to pass by value instead of by address.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20200109012416.2875-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/usb/usbip/src/usbip_network.c | 40 +++++++++++++++++------------
 tools/usb/usbip/src/usbip_network.h | 12 +++------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/tools/usb/usbip/src/usbip_network.c b/tools/usb/usbip/src/usbip_network.c
index b4c37e76a6e08..187dfaa67d0a2 100644
--- a/tools/usb/usbip/src/usbip_network.c
+++ b/tools/usb/usbip/src/usbip_network.c
@@ -62,39 +62,39 @@ void usbip_setup_port_number(char *arg)
 	info("using port %d (\"%s\")", usbip_port, usbip_port_string);
 }
 
-void usbip_net_pack_uint32_t(int pack, uint32_t *num)
+uint32_t usbip_net_pack_uint32_t(int pack, uint32_t num)
 {
 	uint32_t i;
 
 	if (pack)
-		i = htonl(*num);
+		i = htonl(num);
 	else
-		i = ntohl(*num);
+		i = ntohl(num);
 
-	*num = i;
+	return i;
 }
 
-void usbip_net_pack_uint16_t(int pack, uint16_t *num)
+uint16_t usbip_net_pack_uint16_t(int pack, uint16_t num)
 {
 	uint16_t i;
 
 	if (pack)
-		i = htons(*num);
+		i = htons(num);
 	else
-		i = ntohs(*num);
+		i = ntohs(num);
 
-	*num = i;
+	return i;
 }
 
 void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev)
 {
-	usbip_net_pack_uint32_t(pack, &udev->busnum);
-	usbip_net_pack_uint32_t(pack, &udev->devnum);
-	usbip_net_pack_uint32_t(pack, &udev->speed);
+	udev->busnum = usbip_net_pack_uint32_t(pack, udev->busnum);
+	udev->devnum = usbip_net_pack_uint32_t(pack, udev->devnum);
+	udev->speed = usbip_net_pack_uint32_t(pack, udev->speed);
 
-	usbip_net_pack_uint16_t(pack, &udev->idVendor);
-	usbip_net_pack_uint16_t(pack, &udev->idProduct);
-	usbip_net_pack_uint16_t(pack, &udev->bcdDevice);
+	udev->idVendor = usbip_net_pack_uint16_t(pack, udev->idVendor);
+	udev->idProduct = usbip_net_pack_uint16_t(pack, udev->idProduct);
+	udev->bcdDevice = usbip_net_pack_uint16_t(pack, udev->bcdDevice);
 }
 
 void usbip_net_pack_usb_interface(int pack __attribute__((unused)),
@@ -141,6 +141,14 @@ ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen)
 	return usbip_net_xmit(sockfd, buff, bufflen, 1);
 }
 
+static inline void usbip_net_pack_op_common(int pack,
+					    struct op_common *op_common)
+{
+	op_common->version = usbip_net_pack_uint16_t(pack, op_common->version);
+	op_common->code = usbip_net_pack_uint16_t(pack, op_common->code);
+	op_common->status = usbip_net_pack_uint32_t(pack, op_common->status);
+}
+
 int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 {
 	struct op_common op_common;
@@ -152,7 +160,7 @@ int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 	op_common.code    = code;
 	op_common.status  = status;
 
-	PACK_OP_COMMON(1, &op_common);
+	usbip_net_pack_op_common(1, &op_common);
 
 	rc = usbip_net_send(sockfd, &op_common, sizeof(op_common));
 	if (rc < 0) {
@@ -176,7 +184,7 @@ int usbip_net_recv_op_common(int sockfd, uint16_t *code)
 		goto err;
 	}
 
-	PACK_OP_COMMON(0, &op_common);
+	usbip_net_pack_op_common(0, &op_common);
 
 	if (op_common.version != USBIP_VERSION) {
 		dbg("version mismatch: %d %d", op_common.version,
diff --git a/tools/usb/usbip/src/usbip_network.h b/tools/usb/usbip/src/usbip_network.h
index c1e875cf1078c..573fa839b66b7 100644
--- a/tools/usb/usbip/src/usbip_network.h
+++ b/tools/usb/usbip/src/usbip_network.h
@@ -33,12 +33,6 @@ struct op_common {
 
 } __attribute__((packed));
 
-#define PACK_OP_COMMON(pack, op_common)  do {\
-	usbip_net_pack_uint16_t(pack, &(op_common)->version);\
-	usbip_net_pack_uint16_t(pack, &(op_common)->code);\
-	usbip_net_pack_uint32_t(pack, &(op_common)->status);\
-} while (0)
-
 /* ---------------------------------------------------------------------- */
 /* Dummy Code */
 #define OP_UNSPEC	0x00
@@ -164,11 +158,11 @@ struct op_devlist_reply_extra {
 } while (0)
 
 #define PACK_OP_DEVLIST_REPLY(pack, reply)  do {\
-	usbip_net_pack_uint32_t(pack, &(reply)->ndev);\
+	(reply)->ndev = usbip_net_pack_uint32_t(pack, (reply)->ndev);\
 } while (0)
 
-void usbip_net_pack_uint32_t(int pack, uint32_t *num);
-void usbip_net_pack_uint16_t(int pack, uint16_t *num);
+uint32_t usbip_net_pack_uint32_t(int pack, uint32_t num);
+uint16_t usbip_net_pack_uint16_t(int pack, uint16_t num);
 void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
 void usbip_net_pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
 
-- 
2.20.1



