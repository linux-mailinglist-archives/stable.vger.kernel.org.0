Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5154434C658
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhC2IGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232283AbhC2IFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A772B61932;
        Mon, 29 Mar 2021 08:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005147;
        bh=BHsNB7quJZdZFvbZOrwC2cF4dGnW5p9yOwa4oPSFHmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZKSLWjz27pyWchikbdvUW54pvndgO2olb7QXumQQG4JeIL91fyCys8vm/2CpgUl/
         nlXKdsmu8ZfaDT0YX+Uw19Vk5RSjjKg8yhUK9VFkhyW7rVog6cKQt4KPEySgj5iyw9
         7hsRJLKej0LxE2hPXV6VldtGGrA0CYcuKqmHlA5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 42/59] net: cdc-phonet: fix data-interface release on probe failure
Date:   Mon, 29 Mar 2021 09:58:22 +0200
Message-Id: <20210329075610.271037779@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
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
index 288ecd999171..7a18eb0784f3 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -398,6 +398,8 @@ static int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	err = register_netdev(dev);
 	if (err) {
+		/* Set disconnected flag so that disconnect() returns early. */
+		pnd->disconnected = 1;
 		usb_driver_release_interface(&usbpn_driver, data_intf);
 		goto out;
 	}
-- 
2.30.1



