Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DA71A51E7
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgDKMLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgDKMLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:11:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A535B20787;
        Sat, 11 Apr 2020 12:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607066;
        bh=lNTvev1ynm4GTeHYKUBo21kiveX5swSgmd0QLan0xXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTUXbOEy88TjkX60Vh0aAJgIRmB6Eg2V51hYrN/B5soOfIhYeW3nKoivbB6Xb3xMi
         EZuF7V48Biw11OM2GQsdUL3gyG88EFtjIvqchJEsZ0zbl0LFgpdXaovXgJfweWW44d
         UoJFh/GS5jl2djeus2TcteV+Wriz38lG78k93I3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Shepherd <liam@dancer.es>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 23/29] xen-netfront: Update features after registering netdev
Date:   Sat, 11 Apr 2020 14:08:53 +0200
Message-Id: <20200411115411.643981759@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
References: <20200411115407.651296755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit 45c8184c1bed1ca8a7f02918552063a00b909bf5 upstream.

Update the features after calling register_netdev() otherwise the
device features are not set up correctly and it not possible to change
the MTU of the device. After this change, the features reported by
ethtool match the device's features before the commit which introduced
the issue and it is possible to change the device's MTU.

Fixes: f599c64fdf7d ("xen-netfront: Fix race between device setup and open")
Reported-by: Liam Shepherd <liam@dancer.es>
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netfront.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1982,10 +1982,6 @@ static int xennet_connect(struct net_dev
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;
 
-	rtnl_lock();
-	netdev_update_features(dev);
-	rtnl_unlock();
-
 	if (dev->reg_state == NETREG_UNINITIALIZED) {
 		err = register_netdev(dev);
 		if (err) {
@@ -1995,6 +1991,10 @@ static int xennet_connect(struct net_dev
 		}
 	}
 
+	rtnl_lock();
+	netdev_update_features(dev);
+	rtnl_unlock();
+
 	/*
 	 * All public and private state should now be sane.  Get
 	 * ready to start sending and receiving packets and give the driver


