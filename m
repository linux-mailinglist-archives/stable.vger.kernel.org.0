Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7524D150C17
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgBCQdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730552AbgBCQdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:15 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5B221744;
        Mon,  3 Feb 2020 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747594;
        bh=uIkKumRBHYw41z1WXD1gPbkheu9s+2Iypt+INQEIzzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr1s1653z7x4THtQ1SEt/qY9TB6dY2Iwky0U7wY6OktO+1uxezXNdoxoayJHHjSe3
         Xa9+eKSPfDZ6FFtHQRFd90DIA7geroKbc7N0VC5/QmeHwHhh6mM591CMbNRr1N0rdz
         +h0Gcyd1diltJ/6zhkrLGSBR62qKF9QhyhnfWAr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/70] airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
Date:   Mon,  3 Feb 2020 16:20:12 +0000
Message-Id: <20200203161920.857388193@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/cisco/airo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 5512c7f73fce8..9344cf17d6b11 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -7809,7 +7809,7 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 		return -EINVAL;
 	}
 
-	if ((iobuf = kmalloc(RIDSIZE, GFP_KERNEL)) == NULL)
+	if ((iobuf = kzalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
 	PC4500_readrid(ai,ridcode,iobuf,RIDSIZE, 1);
-- 
2.20.1



