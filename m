Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544C84120C6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350039AbhITR56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354096AbhITRzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0FC66138E;
        Mon, 20 Sep 2021 17:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158049;
        bh=mDuoWapFqV0jiXQQk61Qj4RtGsTKWqG2+oyPpVYKY8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwN/rTIJGvRTp8jCb/i2o8YnGF/fKr425YXD/7famL0iRx94rRF+aa3v3Q0h0putE
         80K4nNM6uRhfsromVKT1QegKrpThkqIAu6wqpLLw36Tv0hx8WqCASIpx9uZwCTlHsv
         MkHc4sBd7pxebjLsVr8vCGl0t40UDCUF7T/2Ooqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 271/293] ibmvnic: check failover_pending in login response
Date:   Mon, 20 Sep 2021 18:43:53 +0200
Message-Id: <20210920163942.686171527@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -4038,6 +4038,14 @@ static int handle_login_rsp(union ibmvni
 		return 0;
 	}
 
+	if (adapter->failover_pending) {
+		adapter->init_done_rc = -EAGAIN;
+		netdev_dbg(netdev, "Failover pending, ignoring login response\n");
+		complete(&adapter->init_done);
+		/* login response buffer will be released on reset */
+		return 0;
+	}
+
 	netdev->mtu = adapter->req_mtu - ETH_HLEN;
 
 	netdev_dbg(adapter->netdev, "Login Response Buffer:\n");


