Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B9F41240C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378269AbhITSaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379125AbhITS2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4BF46135D;
        Mon, 20 Sep 2021 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158769;
        bh=XMxsPSm9nFBFzM0KXG1wk+yQ8h1SAVnoQu3yCJFs9q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhTBU8/tx9niHpvLpJGDpRm0WeV+BJ8dYLfsoxB2CKi4ScE7dHMoEp0+E6Jpvwi5P
         TvbO5gzzzzbOCiPlyT5n9qhvYhibfsiq0QEf4qhXrfCmGlC8hVH6SEyT2YFB0BlMzX
         f8/iMhuxDLrUNIw3drM6bxsIFYWXebispkTdp34E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 047/122] ibmvnic: check failover_pending in login response
Date:   Mon, 20 Sep 2021 18:43:39 +0200
Message-Id: <20210920163917.334587853@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
@@ -4478,6 +4478,14 @@ static int handle_login_rsp(union ibmvni
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


