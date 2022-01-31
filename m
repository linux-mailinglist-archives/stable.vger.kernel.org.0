Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4544A4A4103
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358507AbiAaLBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60416 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358623AbiAaLAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7127960ABE;
        Mon, 31 Jan 2022 11:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A02C340E8;
        Mon, 31 Jan 2022 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626836;
        bh=hp3tUhukj1H0fyjDpKJuoQvkedvjJfb9P/laApICm3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRN+IdXbopUU+c5ECz+aWD9it4YvrYaT56rMZWIm4DDvKMTYqWIbgUSp3/OdcaL9L
         va9GuRWioHVG6swnFbvQoMBhId0ZH5kjED8EiigRe3TkhL7dLdX5s3tRj2W7cHR2Ot
         kcrWIF/FkBpGjiHixLcayL/bypCU2ALPhtcd4daY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/64] ibmvnic: dont spin in tasklet
Date:   Mon, 31 Jan 2022 11:56:40 +0100
Message-Id: <20220131105217.538146815@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 48079e7fdd0269d66b1d7d66ae88bd03162464ad ]

ibmvnic_tasklet() continuously spins waiting for responses to all
capability requests. It does this to avoid encountering an error
during initialization of the vnic. However if there is a bug in the
VIOS and we do not receive a response to one or more queries the
tasklet ends up spinning continuously leading to hard lock ups.

If we fail to receive a message from the VIOS it is reasonable to
timeout the login attempt rather than spin indefinitely in the tasklet.

Fixes: 249168ad07cd ("ibmvnic: Make CRQ interrupt tasklet wait for all capabilities crqs")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6ecbe70614378..26d49dcdbeb3e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4823,12 +4823,6 @@ static void ibmvnic_tasklet(void *data)
 			ibmvnic_handle_crq(crq, adapter);
 			crq->generic.first = 0;
 		}
-
-		/* remain in tasklet until all
-		 * capabilities responses are received
-		 */
-		if (!adapter->wait_capability)
-			done = true;
 	}
 	/* if capabilities CRQ's were sent in this tasklet, the following
 	 * tasklet must wait until all responses are received
-- 
2.34.1



