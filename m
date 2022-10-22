Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F79608A5E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbiJVIvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbiJVIuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:50:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F492F0462;
        Sat, 22 Oct 2022 01:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C56DBB82DF3;
        Sat, 22 Oct 2022 08:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E097C433C1;
        Sat, 22 Oct 2022 08:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426108;
        bh=GmRUeDbFgkpqIs8eExCjyoabv5cVnd0mR8YC0z3X1xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEbL3ChDVIk2ORUYSXCONJ1f3m0jspVsSZR4doKOulDUd5Uc6MMRF/fSrFm2gEAFV
         bet7N0FgEjHlEYX96luEcySj0sx4/1U9yI3y16XwgYimGF/TP44bDfrBqj0hSCwBxB
         rWOKeDJwoT/ICmHm5ZVTVMO+OgxCWNo16j72hLBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 691/717] fsi: occ: Prevent use after free
Date:   Sat, 22 Oct 2022 09:29:30 +0200
Message-Id: <20221022072529.046151502@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



