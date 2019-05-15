Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084CC1EFC5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfEOLgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732717AbfEOLdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:33:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146472053B;
        Wed, 15 May 2019 11:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919981;
        bh=NhgZtDE+kJfP2c9ihs85vwuYjgcxXW1BjKaxNGSvzRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHspNJj/9kMn0915QchZBFnp+HLwVHyDdgf3Q8EntvVT2eIpgzRhaYVqNmAsH7wVk
         qia+VsGe0AZDsTp4cb4ypor0ErRT4sAq/dpheVUfQXBm9Q/MOgeASfX1FPCGfDJVQX
         5tXj0vFnrJlL6fzX9fYhbmExqzn/vNTrfhZfvZXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 29/46] aqc111: fix endianness issue in aqc111_change_mtu
Date:   Wed, 15 May 2019 12:56:53 +0200
Message-Id: <20190515090626.092268427@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b8b277525e9df2fd2dc3d1f4fe01c6796bb107fc ]

If the MTU is large enough, the first write to the device
is just repeated. On BE architectures, however, the first
word of the command will be swapped a second time and garbage
will be written. Avoid that.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/aqc111.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -453,6 +453,8 @@ static int aqc111_change_mtu(struct net_
 		reg16 = 0x1420;
 	else if (dev->net->mtu <= 16334)
 		reg16 = 0x1A20;
+	else
+		return 0;
 
 	aqc111_write16_cmd(dev, AQ_ACCESS_MAC, SFR_PAUSE_WATERLVL_LOW,
 			   2, &reg16);


