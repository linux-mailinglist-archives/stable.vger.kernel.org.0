Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB9428B9FF
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgJLNe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbgJLNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF5F221FE;
        Mon, 12 Oct 2020 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509638;
        bh=XHhT+BWI5pRqE+V74UmBpgVn+ChE0exEXSay7jL+qHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uvs/GUYIkobip4yzjoldn/PAL5ilLhnprLPld9KBnktCAQMlXHatVqVaeByH6HrqH
         Tpxzc9dFO/lgaQH3ib9cwxgIGO00Yrw0XI1Z8qChRzr0IkDFgid4wwPOFBURiqfipU
         /Hozm0SQCYGQ9Rcue4uLRpjeG96V59ex0uB+31qQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olympia Giannou <olympia.giannou@leica-geosystems.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/54] rndis_host: increase sleep time in the query-response loop
Date:   Mon, 12 Oct 2020 15:26:30 +0200
Message-Id: <20201012132629.979198020@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
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
index 4f4f71b2966ba..9ccbdf1431063 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -213,7 +213,7 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
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



