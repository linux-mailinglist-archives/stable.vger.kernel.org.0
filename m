Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B94234C5A2
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhC2IBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231653AbhC2IBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8041F6196B;
        Mon, 29 Mar 2021 08:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004885;
        bh=i6PZcyS32+Q2rUoQb+Rle8pEw7OWb2VASrVtpl35CK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgCDKUJn+1XecB+Iz/FNR6/o7nXYWhpKWGhTkMIa0IHXoWK9t2HKTBZqdvdKNRWK7
         267YCW7ftJ1I+b4QLZp4teWeoqGBYt3MopFL8YU98JO1EBVwkgbkPOHqJ7f9pwYJ0p
         8zt4PZns3cQ3nERiJaV3Np+fX+v4tKsms11Hfjts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 28/33] net: cdc-phonet: fix data-interface release on probe failure
Date:   Mon, 29 Mar 2021 09:58:13 +0200
Message-Id: <20210329075606.163325635@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c79a707072fe3fea0e3c92edee6ca85c1e53c29f ]

Set the disconnected flag before releasing the data interface in case
netdev registration fails to avoid having the disconnect callback try to
deregister the never registered netdev (and trigger a WARN_ON()).

Fixes: 87cf65601e17 ("USB host CDC Phonet network interface driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc-phonet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index ff2270ead2e6..84e0e7f78029 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -406,6 +406,8 @@ static int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	err = register_netdev(dev);
 	if (err) {
+		/* Set disconnected flag so that disconnect() returns early. */
+		pnd->disconnected = 1;
 		usb_driver_release_interface(&usbpn_driver, data_intf);
 		goto out;
 	}
-- 
2.30.1



