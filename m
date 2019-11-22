Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC241106E28
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbfKVLGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731865AbfKVLGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD4720872;
        Fri, 22 Nov 2019 11:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420797;
        bh=1tGftarjUnn0WkDsVLhvxVIToADcwZUnJ117RERnNJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwUu8Ag/0bnypf63Al8OYiLzU3aGGN1ANNXQLeHN4LnDmWD16n9EMipOaijziExrv
         K5KT/TVabjHlYnYdGnBBnZ1ZaG5wv1plgpMsqMi2w7mPuLb65ZFPrLgNyyzAWn2DN9
         pLAofcKoPHA7J2a/7avxeOedjNyabeD0vvacww0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.3 1/6] net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()
Date:   Fri, 22 Nov 2019 11:30:03 +0100
Message-Id: <20191122100322.128248608@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100320.878809004@linuxfoundation.org>
References: <20191122100320.878809004@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a56dcc6b455830776899ce3686735f1172e12243 upstream.

This code is supposed to test for negative error codes and partial
reads, but because sizeof() is size_t (unsigned) type then negative
error codes are type promoted to high positive values and the condition
doesn't work as expected.

Fixes: 332f989a3b00 ("CDC-NCM: handle incomplete transfer of MTU")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -579,7 +579,7 @@ static void cdc_ncm_set_dgram_size(struc
 	err = usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
 			      USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_INTERFACE,
 			      0, iface_no, &max_datagram_size, sizeof(max_datagram_size));
-	if (err < sizeof(max_datagram_size)) {
+	if (err != sizeof(max_datagram_size)) {
 		dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n");
 		goto out;
 	}


