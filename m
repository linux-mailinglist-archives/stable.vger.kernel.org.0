Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E0117813B
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbgCCSBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387627AbgCCSBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 339A42072D;
        Tue,  3 Mar 2020 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258481;
        bh=qVx15RFKk4PNvGJ/mLn44ftM9J4PGdu5vcJo9CUXlkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPz0ia5Q839z0KJk1hBP2WM7CHtb4qPvvYG6eMyPT1gWOPZ8QlY9nl3pnB6U2kR62
         AD2q9iUkdxM6DH2mDleafxMIKX6342oGW4tJ2UIxQ6TqXe7nxa4uYEdmlY/MW0wVMU
         +L7/2C7tuiBPFnuQgX/ed4wjGysqF9uZlzSAE85g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Belous <pbelous@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 64/87] net: atlantic: fix potential error handling
Date:   Tue,  3 Mar 2020 18:43:55 +0100
Message-Id: <20200303174356.086143384@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Belous <pbelous@marvell.com>

commit 380ec5b9af7f0d57dbf6ac067fd9f33cff2fef71 upstream.

Code inspection found that in case of mapping error we do return current
'ret' value. But beside error, it is used to count number of descriptors
allocated for the packet. In that case map_skb function could return '1'.

Changing it to return zero (number of mapped descriptors for skb)

Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")
Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -399,8 +399,10 @@ static unsigned int aq_nic_map_skb(struc
 				     dx_buff->len,
 				     DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(aq_nic_get_dev(self), dx_buff->pa)))
+	if (unlikely(dma_mapping_error(aq_nic_get_dev(self), dx_buff->pa))) {
+		ret = 0;
 		goto exit;
+	}
 
 	first = dx_buff;
 	dx_buff->len_pkt = skb->len;


