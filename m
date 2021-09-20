Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0E8411E7B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343756AbhITRbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350577AbhITR3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:29:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 606A861ACF;
        Mon, 20 Sep 2021 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157430;
        bh=SQjGFetPpk6N4GBoD1LNmVG9aoBGJ4mJk14APzbS0vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdWJpGXVFqN78TE1OFFK5X7F+IKNUWfAB04Ei6sEU8ZBTgMbKJ5ZSyJTYq7gKCkxv
         WisyQAed3mXKjD0i3F+v4aqbVnr4Giakf9DAx9/HQQHCop8idTRpCP7VwDtjC4gqXV
         87NrLL+zQeKqoT46L7W8MInWSOfEgWMZoRpdtAAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 204/217] ibmvnic: check failover_pending in login response
Date:   Mon, 20 Sep 2021 18:43:45 +0200
Message-Id: <20210920163931.540119838@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

commit 273c29e944bda9a20a30c26cfc34c9a3f363280b upstream.

If a failover occurs before a login response is received, the login
response buffer maybe undefined. Check that there was no failover
before accessing the login response buffer.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3965,6 +3965,14 @@ static int ibmvnic_probe(struct vio_dev
 			goto ibmvnic_init_fail;
 	} while (rc == EAGAIN);
 
+	if (adapter->failover_pending) {
+		adapter->init_done_rc = -EAGAIN;
+		netdev_dbg(netdev, "Failover pending, ignoring login response\n");
+		complete(&adapter->init_done);
+		/* login response buffer will be released on reset */
+		return 0;
+	}
+
 	netdev->mtu = adapter->req_mtu - ETH_HLEN;
 
 	rc = device_create_file(&dev->dev, &dev_attr_failover);


