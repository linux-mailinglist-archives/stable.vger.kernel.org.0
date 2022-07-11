Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B7856FC8C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiGKJpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiGKJoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4372EA2E6E;
        Mon, 11 Jul 2022 02:22:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A92BD612E8;
        Mon, 11 Jul 2022 09:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CC0C34115;
        Mon, 11 Jul 2022 09:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531319;
        bh=nQtP9y8c4IgLOcZn+HDIIgDf2vPne8ZLgK4tRrshfMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uj5fX9Jw+LPDYv5xsbPsSX3KYJJsl5DhQoDl36pObENxhAVmahAl1i2QkguQ0Bhhd
         +c3ki2VFkSugbaDdIVn8eEEHOkmuQvwHcCzyCMXBcBXCVTJPaHe6OUB7CWppCV494P
         ywiVF7h49+t7VV64t5R4x7rgYWZeiY/2XzOHcC0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/230] ibmvnic: clear fop when retrying probe
Date:   Mon, 11 Jul 2022 11:05:19 +0200
Message-Id: <20220711090605.864445518@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 70267bd73429..9f4f40564d74 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5612,6 +5612,11 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
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
2.35.1



