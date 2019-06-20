Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C434D7C6
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfFTSKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbfFTSKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A2322082C;
        Thu, 20 Jun 2019 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054215;
        bh=MnLRgpKf8bf7JXa3l3G1EigBR7h3gNLETgMTq6ZJNU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhSn1y+0YvZ39csa3J+UbRR2ahqhULarDMKkKf2IgRUMuav5QEFJIkPUV/K9pSimB
         lJvRWgqjVBn1vS/FPjs8fplv7si0Wn0MS3mCr1d0FptGhkY2ECKmp2nfwctU8rBt56
         N/gUVoYGsRp288JA7z68aDOHx9a+bsK4zGudaRx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+afb980676c836b4a0afa@syzkaller.appspotmail.com,
        Jeremy Sowden <jeremy@azazel.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 05/61] lapb: fixed leak of control-blocks.
Date:   Thu, 20 Jun 2019 19:57:00 +0200
Message-Id: <20190620174338.536691075@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 6be8e297f9bcea666ea85ac7a6cd9d52d6deaf92 ]

lapb_register calls lapb_create_cb, which initializes the control-
block's ref-count to one, and __lapb_insert_cb, which increments it when
adding the new block to the list of blocks.

lapb_unregister calls __lapb_remove_cb, which decrements the ref-count
when removing control-block from the list of blocks, and calls lapb_put
itself to decrement the ref-count before returning.

However, lapb_unregister also calls __lapb_devtostruct to look up the
right control-block for the given net_device, and __lapb_devtostruct
also bumps the ref-count, which means that when lapb_unregister returns
the ref-count is still 1 and the control-block is leaked.

Call lapb_put after __lapb_devtostruct to fix leak.

Reported-by: syzbot+afb980676c836b4a0afa@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/lapb/lapb_iface.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -182,6 +182,7 @@ int lapb_unregister(struct net_device *d
 	lapb = __lapb_devtostruct(dev);
 	if (!lapb)
 		goto out;
+	lapb_put(lapb);
 
 	lapb_stop_t1timer(lapb);
 	lapb_stop_t2timer(lapb);


