Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F425FD010
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiJMAY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiJMAXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172E51055E;
        Wed, 12 Oct 2022 17:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9799B81CCD;
        Thu, 13 Oct 2022 00:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6FEC43470;
        Thu, 13 Oct 2022 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620300;
        bh=GmRUeDbFgkpqIs8eExCjyoabv5cVnd0mR8YC0z3X1xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhWe5kIOEJWqZLR9X9/yB18bHLWdiWByUY2SNyEOPqyEsiCF7zy04abPYxXInxL9f
         U3EIjRI2MqT91LeTIEbuLVxLfPdjHGdj087jMqPsmzvWq1bl9hEzbSS3lE3iKGRCzI
         hW05TF7M8JqSQ4K/ls/N/KucUKpQfv8NAy/d5E4e0dLX5aXhXhQxYAb3Kg4b3pMw01
         BiqeUGoM21ECqyfY04QznCJ8RA47h7w8FUfcKRLagXXvee37B91gCBaxTad/L2crNy
         R9VR/haG4cvDCLGO6ENgj5aVGeEUEzYFFROjb0sJ7gDyzKwG81wXW7fOkBpccyW/7I
         6D+5ENAmKMGqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>,
        jk@ozlabs.org, linux-fsi@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.0 61/67] fsi: occ: Prevent use after free
Date:   Wed, 12 Oct 2022 20:15:42 -0400
Message-Id: <20221013001554.1892206-61-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit d3e1e24604031b0d83b6c2d38f54eeea265cfcc0 ]

Use get_device and put_device in the open and close functions to
make sure the device doesn't get freed while a file descriptor is
open.
Also, lock around the freeing of the device buffer and check the
buffer before using it in the submit function.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220513194424.53468-1-eajames@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-occ.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/fsi/fsi-occ.c b/drivers/fsi/fsi-occ.c
index c9cc75fbdfb9..28c176d038a2 100644
--- a/drivers/fsi/fsi-occ.c
+++ b/drivers/fsi/fsi-occ.c
@@ -94,6 +94,7 @@ static int occ_open(struct inode *inode, struct file *file)
 	client->occ = occ;
 	mutex_init(&client->lock);
 	file->private_data = client;
+	get_device(occ->dev);
 
 	/* We allocate a 1-page buffer, make sure it all fits */
 	BUILD_BUG_ON((OCC_CMD_DATA_BYTES + 3) > PAGE_SIZE);
@@ -197,6 +198,7 @@ static int occ_release(struct inode *inode, struct file *file)
 {
 	struct occ_client *client = file->private_data;
 
+	put_device(client->occ->dev);
 	free_page((unsigned long)client->buffer);
 	kfree(client);
 
@@ -493,12 +495,19 @@ int fsi_occ_submit(struct device *dev, const void *request, size_t req_len,
 	for (i = 1; i < req_len - 2; ++i)
 		checksum += byte_request[i];
 
-	mutex_lock(&occ->occ_lock);
+	rc = mutex_lock_interruptible(&occ->occ_lock);
+	if (rc)
+		return rc;
 
 	occ->client_buffer = response;
 	occ->client_buffer_size = user_resp_len;
 	occ->client_response_size = 0;
 
+	if (!occ->buffer) {
+		rc = -ENOENT;
+		goto done;
+	}
+
 	/*
 	 * Get a sequence number and update the counter. Avoid a sequence
 	 * number of 0 which would pass the response check below even if the
@@ -671,10 +680,13 @@ static int occ_remove(struct platform_device *pdev)
 {
 	struct occ *occ = platform_get_drvdata(pdev);
 
-	kvfree(occ->buffer);
-
 	misc_deregister(&occ->mdev);
 
+	mutex_lock(&occ->occ_lock);
+	kvfree(occ->buffer);
+	occ->buffer = NULL;
+	mutex_unlock(&occ->occ_lock);
+
 	device_for_each_child(&pdev->dev, NULL, occ_unregister_child);
 
 	ida_simple_remove(&occ_ida, occ->idx);
-- 
2.35.1

