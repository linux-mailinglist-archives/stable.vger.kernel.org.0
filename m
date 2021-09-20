Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837FE41259B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384110AbhITSqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383268AbhITSoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B054B63350;
        Mon, 20 Sep 2021 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159155;
        bh=nrNPpN0BpsIoPy+DSzCrXL6W0dKWqnRGJwtvstcOXu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vftL+mBIdUgtYKCKsfxGBt65sHScj1m1uwrr3gyu7OJAkjjfPZ85eQPBW+te/DRxS
         tyrpH0H2bFtP7hmYyXQ8F69rxSfgFeZ89kTE6zRfL/tqQUjiCgpD8FmZeHdZk5AVNs
         bIyIRAVlFSYakNIctxt4+RtsYyoEL+kt9MhyJ5tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 069/168] ibmvnic: check failover_pending in login response
Date:   Mon, 20 Sep 2021 18:43:27 +0200
Message-Id: <20210920163923.912216376@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -4700,6 +4700,14 @@ static int handle_login_rsp(union ibmvni
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


