Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7284ABAA8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383982AbiBGLYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352055AbiBGLLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50558C043181;
        Mon,  7 Feb 2022 03:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2FE2B80EC3;
        Mon,  7 Feb 2022 11:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B46AC004E1;
        Mon,  7 Feb 2022 11:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232304;
        bh=XlE85Z5zOnoqCqnlZdZMCtne7tKQO+tuwpoBNZgBrK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFXLyhXNNbkH4etQXY2ZiCSa0mK1Lq2gD7d1qCWQ0XncyiJbxLW4m22n8gK/Z5p45
         dSDRbGyo/M8xkzDwSedkwKBVjjzt6aOWpDF8sdtGSrVQUrFjw93HH8ej/HO8HjZQya
         NzTJG3GEC4dFARmP0S2gSUjjHwn6CyfruFc18YT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/69] ibmvnic: dont spin in tasklet
Date:   Mon,  7 Feb 2022 12:05:56 +0100
Message-Id: <20220207103756.750226254@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 4befc885efb8d..8d8eb9e2465ff 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3691,12 +3691,6 @@ static void ibmvnic_tasklet(void *data)
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



