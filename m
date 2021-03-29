Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B0634C78F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhC2IQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232936AbhC2IOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A058E61481;
        Mon, 29 Mar 2021 08:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005688;
        bh=sZvI42GUOkQjiXCr3sVO3przbU+jstsNxuX6Dbary1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX38Gel2LGbscLf6co7hV9uYUVuL6iwJuYQm/vlR9uIp0ZIEkrHuTna+0z475xB9v
         0azY2tFBKhkummf35CsBxkR2wQU0BXrgAiTjDgLQJlTiKlfuwzOFiOmnhixDU+748w
         UrkEAtSTRHNDj+XS0fLSa6VXPoq1NI0ZoTuuvNPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/111] net: cdc-phonet: fix data-interface release on probe failure
Date:   Mon, 29 Mar 2021 09:58:30 +0200
Message-Id: <20210329075617.941682764@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
index bcabd39d136a..f778172356e6 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -387,6 +387,8 @@ static int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	err = register_netdev(dev);
 	if (err) {
+		/* Set disconnected flag so that disconnect() returns early. */
+		pnd->disconnected = 1;
 		usb_driver_release_interface(&usbpn_driver, data_intf);
 		goto out;
 	}
-- 
2.30.1



