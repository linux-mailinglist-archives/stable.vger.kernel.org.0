Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBB366EAA
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbfGLMYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbfGLMYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:24:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5229D2084B;
        Fri, 12 Jul 2019 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934289;
        bh=kD7Fglm7ijDxctsdE46ohXgEikesjUR13C+dfx4w0IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RiIgUz6+66Mos+BiN22OEhVIPEyIY5MHAc6E307ujmo8kXiruqLFLmLiNkvNqOTI
         wEqcceS9FE19Gx4IlW3TNOIbY8eG077nbGDEgfbbrk8aLgeJg1F5dZ7d5S3vAROxzm
         dsvoIWtfxujwidoivgs0kw0x/00NezOYnIj9TVpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Reinhard Speyerer <rspmn@arcor.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/91] qmi_wwan: extend permitted QMAP mux_id value range
Date:   Fri, 12 Jul 2019 14:18:47 +0200
Message-Id: <20190712121623.887647543@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 36815b416fa48766ac5a98e4b2dc3ebc5887222e ]

Permit mux_id values up to 254 to be used in qmimux_register_device()
for compatibility with ip(8) and the rmnet driver.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-net-qmi | 4 ++--
 drivers/net/usb/qmi_wwan.c                    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-qmi b/Documentation/ABI/testing/sysfs-class-net-qmi
index 7122d6264c49..c310db4ccbc2 100644
--- a/Documentation/ABI/testing/sysfs-class-net-qmi
+++ b/Documentation/ABI/testing/sysfs-class-net-qmi
@@ -29,7 +29,7 @@ Contact:	Bjørn Mork <bjorn@mork.no>
 Description:
 		Unsigned integer.
 
-		Write a number ranging from 1 to 127 to add a qmap mux
+		Write a number ranging from 1 to 254 to add a qmap mux
 		based network device, supported by recent Qualcomm based
 		modems.
 
@@ -46,5 +46,5 @@ Contact:	Bjørn Mork <bjorn@mork.no>
 Description:
 		Unsigned integer.
 
-		Write a number ranging from 1 to 127 to delete a previously
+		Write a number ranging from 1 to 254 to delete a previously
 		created qmap mux based network device.
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 44ada5c38756..128c8a327d8e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -363,8 +363,8 @@ static ssize_t add_mux_store(struct device *d,  struct device_attribute *attr, c
 	if (kstrtou8(buf, 0, &mux_id))
 		return -EINVAL;
 
-	/* mux_id [1 - 0x7f] range empirically found */
-	if (mux_id < 1 || mux_id > 0x7f)
+	/* mux_id [1 - 254] for compatibility with ip(8) and the rmnet driver */
+	if (mux_id < 1 || mux_id > 254)
 		return -EINVAL;
 
 	if (!rtnl_trylock())
-- 
2.20.1



