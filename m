Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961D4A90E4
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389261AbfIDSMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390483AbfIDSMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:12:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4B2208E4;
        Wed,  4 Sep 2019 18:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620742;
        bh=JGrzN6UeZqnNk2EPqbW69dSFxVo/JYTqdlEC7Nk+WQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZABwiQk8lpyN2X19jM9S0dnHjJ7EBRmZyHADVBs1Pk8TcteL81KALqRwQ/FHLrtn
         hb49g30Ss+qsjj+p4VL9Rf0/da7NhzXcyUnuoeVVVH1dBMiPWuD5MArrYFSL+QXLQh
         Rhb2eBy76HRSm/osGOQ0LkDaWcz43eGxAbrZ54iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.2 078/143] usbtmc: more sanity checking for packet size
Date:   Wed,  4 Sep 2019 19:53:41 +0200
Message-Id: <20190904175317.111350107@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit de7b9aa633b693e77942e12f1769506efae6917b upstream.

A malicious device can make the driver divide ny zero
with a nonsense maximum packet size.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190820092826.17694-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/usbtmc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2362,8 +2362,11 @@ static int usbtmc_probe(struct usb_inter
 		goto err_put;
 	}
 
+	retcode = -EINVAL;
 	data->bulk_in = bulk_in->bEndpointAddress;
 	data->wMaxPacketSize = usb_endpoint_maxp(bulk_in);
+	if (!data->wMaxPacketSize)
+		goto err_put;
 	dev_dbg(&intf->dev, "Found bulk in endpoint at %u\n", data->bulk_in);
 
 	data->bulk_out = bulk_out->bEndpointAddress;


