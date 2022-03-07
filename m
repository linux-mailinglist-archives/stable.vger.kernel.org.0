Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCC94CF9D1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiCGKNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiCGKMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:12:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DFE8E188;
        Mon,  7 Mar 2022 01:56:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D7E3B80F9F;
        Mon,  7 Mar 2022 09:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01248C340E9;
        Mon,  7 Mar 2022 09:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646959;
        bh=E39c9wyYGslG9nbRLLtdoSt5SgjZivNNOCW0EZqAUmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IPq1vLAYWUq0LQHzUdlK7xFebXApR9tyCwol8ajKXiqTbsyBRqULIqxCl3Zef/me
         3ShjmJOv5ot5MFetW7+n7dTbDknPCO7v50GseeaPyl8n/vAKz3DgZOUDuz93VESvDj
         vIeqAuC3tpa2i4+DBetcLgMqAgCCe1QcFTNTa5xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 145/186] ibmvnic: clear fop when retrying probe
Date:   Mon,  7 Mar 2022 10:19:43 +0100
Message-Id: <20220307091658.130832635@linuxfoundation.org>
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

[ Upstream commit f628ad531b4f34fdba0984255b4a2850dd369513 ]

Clear ->failover_pending flag that may have been set in the previous
pass of registering CRQ. If we don't clear, a subsequent ibmvnic_open()
call would be misled into thinking a failover is pending and assuming
that the reset worker thread would open the adapter. If this pass of
registering the CRQ succeeds (i.e there is no transport event), there
wouldn't be a reset worker thread.

This would leave the adapter unconfigured and require manual intervention
to bring it up during boot.

Fixes: 5a18e1e0c193 ("ibmvnic: Fix failover case for non-redundant configuration")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 26ea1f32281f..679257d3a3c6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5817,6 +5817,11 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	do {
 		reinit_init_done(adapter);
 
+		/* clear any failovers we got in the previous pass
+		 * since we are reinitializing the CRQ
+		 */
+		adapter->failover_pending = false;
+
 		rc = init_crq_queue(adapter);
 		if (rc) {
 			dev_err(&dev->dev, "Couldn't initialize crq. rc=%d\n",
-- 
2.34.1



