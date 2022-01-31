Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F734A41F5
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348689AbiAaLHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:07:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53422 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359429AbiAaLFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:05:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D812CB82A5F;
        Mon, 31 Jan 2022 11:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BA6C340EF;
        Mon, 31 Jan 2022 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627129;
        bh=ae8R5cR9og/FxynuOn/VIw3QPeA3VAi0XqcCVhZbz3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uacvQwVTPGI6SjWRLWx/D3oAEFcUug3cFDuhkKuERWG1q5cgmld+MWY4G1FlU9Ul
         4Q/nJ6VPdBclrygP59EMd9f9RYuPc29f2XzaJDu2ijaNu7JqrrfMQ9PmEIyILE5xHI
         NgjsxxpalgOkLg3tOpGYUeDUBJQsvj6fgHGvQ3vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/100] ibmvnic: dont spin in tasklet
Date:   Mon, 31 Jan 2022 11:56:45 +0100
Message-Id: <20220131105223.274263195@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
index 232c68af4c60a..c7be7ab131b19 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5075,12 +5075,6 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
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



