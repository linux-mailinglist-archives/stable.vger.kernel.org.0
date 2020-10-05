Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A52839DC
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgJEP3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgJEP3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F67421548;
        Mon,  5 Oct 2020 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911741;
        bh=jCAJpA4MoOkk1Y3avzyE2lD63xoo8nkUKvGvEriN85g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhhIiY1ji94+kxOgTqX36Z+ngYrHayUllf+PzRp/k6A9Audkm07OR5DtYGV12njeG
         AOlFovVhDTqz8Sg5QlbrvCjW5M9LvdOqu/bldM1rLjl/5jlS3/7c60ntf4NARQHruG
         UeM9hA7hUa8QjwVLbJUpMPhrH+lzhqGJ2WzQUkw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olympia Giannou <olympia.giannou@leica-geosystems.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/57] rndis_host: increase sleep time in the query-response loop
Date:   Mon,  5 Oct 2020 17:26:33 +0200
Message-Id: <20201005142110.810250275@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olympia Giannou <ogiannou@gmail.com>

[ Upstream commit 4202c9fdf03d79dedaa94b2c4cf574f25793d669 ]

Some WinCE devices face connectivity issues via the NDIS interface. They
fail to register, resulting in -110 timeout errors and failures during the
probe procedure.

In this kind of WinCE devices, the Windows-side ndis driver needs quite
more time to be loaded and configured, so that the linux rndis host queries
to them fail to be responded correctly on time.

More specifically, when INIT is called on the WinCE side - no other
requests can be served by the Client and this results in a failed QUERY
afterwards.

The increase of the waiting time on the side of the linux rndis host in
the command-response loop leaves the INIT process to complete and respond
to a QUERY, which comes afterwards. The WinCE devices with this special
"feature" in their ndis driver are satisfied by this fix.

Signed-off-by: Olympia Giannou <olympia.giannou@leica-geosystems.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rndis_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index bd9c07888ebb4..6fa7a009a24a4 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -201,7 +201,7 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
 			dev_dbg(&info->control->dev,
 				"rndis response error, code %d\n", retval);
 		}
-		msleep(20);
+		msleep(40);
 	}
 	dev_dbg(&info->control->dev, "rndis response timeout\n");
 	return -ETIMEDOUT;
-- 
2.25.1



