Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5502F6C712
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390968AbfGRDJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390966AbfGRDJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:09:23 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0720A2053B;
        Thu, 18 Jul 2019 03:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419362;
        bh=YuJQYMRVImO70qoTgg8jTkZlMrtG6heLr/F0EfGU5YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lp54stqP7/0AIZJmmCk8aLg7wsXVPvUhuhOzTNvSAg+TBUclo/F5alu2VkFR9kSA
         Vp6P5H3ya7ihQSZ6PlzJh1C0nbijeigq3+tbjT+Zm4TlZfxNG9gOs0snnHHrDZG6cr
         ERx6wYbqINKlb7f5+4lbJQ/6jcpLjtmq6P96GnM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Reinhard Speyerer <rspmn@arcor.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/80] qmi_wwan: extend permitted QMAP mux_id value range
Date:   Thu, 18 Jul 2019 12:01:22 +0900
Message-Id: <20190718030101.106764152@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
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
index 76c4afac71f7..4b0144b2a252 100644
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



