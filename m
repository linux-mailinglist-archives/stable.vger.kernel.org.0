Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA661881EB
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCQK40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgCQK4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:56:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6DDD20658;
        Tue, 17 Mar 2020 10:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442585;
        bh=dkgEUqS5KtuxRC54d3BoclYdmll8tgT4aQFM7RkVz+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZRg4Qy1HwBLZJFnDA3zzxGTz3zyE1jf5+JjvHoccWm0Mwez9ACdbIKTSs8vDUt0z
         9RcZCnyb0lbEbOsKL+C+8r2du+aZ2AM8IsJA88O86J3HKyAfRWjm28Ic0BrjrOGXYj
         59bkI7BsXZxri0Vu9wa9+rF2hdKy3urtQ2GsgsiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bogdanov <dbogdanov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 13/89] net: macsec: update SCI upon MAC address change.
Date:   Tue, 17 Mar 2020 11:54:22 +0100
Message-Id: <20200317103301.435439615@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

[ Upstream commit 6fc498bc82929ee23aa2f35a828c6178dfd3f823 ]

SCI should be updated, because it contains MAC in its first 6 octets.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2886,6 +2886,11 @@ static void macsec_dev_set_rx_mode(struc
 	dev_uc_sync(real_dev, dev);
 }
 
+static sci_t dev_to_sci(struct net_device *dev, __be16 port)
+{
+	return make_sci(dev->dev_addr, port);
+}
+
 static int macsec_set_mac_address(struct net_device *dev, void *p)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
@@ -2907,6 +2912,7 @@ static int macsec_set_mac_address(struct
 
 out:
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
 	return 0;
 }
 
@@ -3188,11 +3194,6 @@ static bool sci_exists(struct net_device
 	return false;
 }
 
-static sci_t dev_to_sci(struct net_device *dev, __be16 port)
-{
-	return make_sci(dev->dev_addr, port);
-}
-
 static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);


