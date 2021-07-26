Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF853D6288
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhGZPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234113AbhGZPfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0900260F6B;
        Mon, 26 Jul 2021 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316167;
        bh=QZl5J38LRB7xb1UKInvyHURs/mgW7zLJR5ykM83Jd2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ypga5UPPyb9j9MPSbhEBhZwlhBLvsJL+W7UgPqLV43RDGY3NYpLoydkgoqZ+WhISR
         tUxGE4yVczHPvblN2DkKRCzg3iQDiwXZjn+SWsKdx9kChdkV1xYseNkleiWSLeyOSt
         HcYJCn07rMxyax3lAkY003Q6qtuIO0kRSyrpB3GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 214/223] bonding: fix build issue
Date:   Mon, 26 Jul 2021 17:40:06 +0200
Message-Id: <20210726153853.181214604@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

commit 5b69874f74cc5707edd95fcdaa757c507ac8af0f upstream.

The commit 9a5605505d9c (" bonding: Add struct bond_ipesc to manage SA") is causing
following build error when XFRM is not selected in kernel config.

lld: error: undefined symbol: xfrm_dev_state_flush
>>> referenced by bond_main.c:3453 (drivers/net/bonding/bond_main.c:3453)
>>>               net/bonding/bond_main.o:(bond_netdev_event) in archive drivers/built-in.a

Fixes: 9a5605505d9c (" bonding: Add struct bond_ipesc to manage SA")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
CC: Taehee Yoo <ap420073@gmail.com>
CC: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3442,7 +3442,9 @@ static int bond_master_netdev_event(unsi
 		return bond_event_changename(event_bond);
 	case NETDEV_UNREGISTER:
 		bond_remove_proc_entry(event_bond);
+#ifdef CONFIG_XFRM_OFFLOAD
 		xfrm_dev_state_flush(dev_net(bond_dev), bond_dev, true);
+#endif /* CONFIG_XFRM_OFFLOAD */
 		break;
 	case NETDEV_REGISTER:
 		bond_create_proc_entry(event_bond);


