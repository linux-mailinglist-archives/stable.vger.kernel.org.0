Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA564CF8EE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiCGKDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240453AbiCGKBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F23100F;
        Mon,  7 Mar 2022 01:48:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C759B8102B;
        Mon,  7 Mar 2022 09:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53089C340E9;
        Mon,  7 Mar 2022 09:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646492;
        bh=UFQkcjIuOWuMxxAzs6ek4vVO/KWNVmlBh8B5nOfECCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz4t20gW12v+t7I6NhFnEV8DMvyr3UJ124II4xP/3nnVegdhVf6BppvNtADyB/WJ5
         3R+L0hrRi9tmzFqEY7H1IljbgJYLafgbWE0a17wirzmT8z/1Ksq4mKtv8GyP+ySUh9
         1ijx+nhb8ntokMhfThTIEUQtWCeG6A+ED5tJhcdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/262] ibmvnic: complete init_done on transport events
Date:   Mon,  7 Mar 2022 10:19:24 +0100
Message-Id: <20220307091709.246203199@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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
index 088c764fe3cd..404921418f42 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5178,6 +5178,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
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



