Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85554CFA07
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiCGKNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242729AbiCGKLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8252E77A9D;
        Mon,  7 Mar 2022 01:55:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6581660E88;
        Mon,  7 Mar 2022 09:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76568C340F3;
        Mon,  7 Mar 2022 09:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646946;
        bh=GfPXcg5jHccKntDEWNH0wepVlina7+j0X/yRTDyoBJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZA8FKzn40tHG4BCWqvky9P2aoc8KyGFsA43qyr16NMMYu0VStXevcusygVBpsbu5
         +8KABRMEH+/nIsHct+WqGQANMmBbGzWbT9ck063Lajp99Jv10zwwQFEclk7puQfSiW
         kWDIzHPDYVW0NB8A2ZuHAQ45tEe8xzz9R3aUQlEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 142/186] ibmvnic: complete init_done on transport events
Date:   Mon,  7 Mar 2022 10:19:40 +0100
Message-Id: <20220307091658.047570817@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 36491f2df9ad2501e5a4ec25d3d95d72bafd2781 ]

If we get a transport event, set the error and mark the init as
complete so the attempt to send crq-init or login fail sooner
rather than wait for the timeout.

Fixes: bbd669a868bb ("ibmvnic: Fix completion structure initialization")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5c8264e3979a..16e772f80ec5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5352,6 +5352,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			adapter->fw_done_rc = -EIO;
 			complete(&adapter->fw_done);
 		}
+
+		/* if we got here during crq-init, retry crq-init */
+		if (!completion_done(&adapter->init_done)) {
+			adapter->init_done_rc = -EAGAIN;
+			complete(&adapter->init_done);
+		}
+
 		if (!completion_done(&adapter->stats_done))
 			complete(&adapter->stats_done);
 		if (test_bit(0, &adapter->resetting))
-- 
2.34.1



