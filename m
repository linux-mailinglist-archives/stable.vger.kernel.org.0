Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFFE14B60B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgA1OBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:01:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgA1OBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:01:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EC2C24685;
        Tue, 28 Jan 2020 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220104;
        bh=XKIqmR/yOlhzJCX0lIwbHQgrpdZT0G1ZKeUb032zTCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LItxagg8vnpwYfuV5hqjCBfAe4wEBQJrIil3SKpWZzjMOg1npS/QcWubQY/yx29r4
         zvTsgtKhrSVXjOp690zq5BTrL8T4EkLvveGDV7IhYj8k8533jYWTkETJKiMZ3B6vqK
         0rQPlWjl6lWxuBUBkS35J9P1XSWg77M0lxAo8Btk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 019/104] airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
Date:   Tue, 28 Jan 2020 14:59:40 +0100
Message-Id: <20200128135819.899539624@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit d6bce2137f5d6bb1093e96d2f801479099b28094 ]

The driver for Cisco Aironet 4500 and 4800 series cards (airo.c),
implements AIROOLDIOCTL/SIOCDEVPRIVATE in airo_ioctl().

The ioctl handler copies an aironet_ioctl struct from userspace, which
includes a command and a length. Some of the commands are handled in
readrids(), which kmalloc()'s a buffer of RIDSIZE (2048) bytes.

That buffer is then passed to PC4500_readrid(), which has two cases.
The else case does some setup and then reads up to RIDSIZE bytes from
the hardware into the kmalloc()'ed buffer.

Here len == RIDSIZE, pBuf is the kmalloc()'ed buffer:

	// read the rid length field
	bap_read(ai, pBuf, 2, BAP1);
	// length for remaining part of rid
	len = min(len, (int)le16_to_cpu(*(__le16*)pBuf)) - 2;
	...
	// read remainder of the rid
	rc = bap_read(ai, ((__le16*)pBuf)+1, len, BAP1);

PC4500_readrid() then returns to readrids() which does:

	len = comp->len;
	if (copy_to_user(comp->data, iobuf, min(len, (int)RIDSIZE))) {

Where comp->len is the user controlled length field.

So if the "rid length field" returned by the hardware is < 2048, and
the user requests 2048 bytes in comp->len, we will leak the previous
contents of the kmalloc()'ed buffer to userspace.

Fix it by kzalloc()'ing the buffer.

Found by Ilja by code inspection, not tested as I don't have the
required hardware.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/cisco/airo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -7813,7 +7813,7 @@ static int readrids(struct net_device *d
 		return -EINVAL;
 	}
 
-	if ((iobuf = kmalloc(RIDSIZE, GFP_KERNEL)) == NULL)
+	if ((iobuf = kzalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
 	PC4500_readrid(ai,ridcode,iobuf,RIDSIZE, 1);


