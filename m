Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1855950B2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiHPEqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiHPEoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B5DD475B;
        Mon, 15 Aug 2022 13:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9E51B8114A;
        Mon, 15 Aug 2022 20:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E60C433C1;
        Mon, 15 Aug 2022 20:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596043;
        bh=t5ImEyorQ3i44pNr0mQgsCc6Po4wNQF3sy5vCvr2iNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hC0f5u5PlGhIiLdMUWk8HbIIaqTdvo95czelstBMbEtqRwUSTsI62AGfNGXRc1Y5H
         B+HpdTJ/omdJBvgPw8tSTZxO8v7isTrMJdU0B2NfZD9QqVAJ7elTIqpCqPnGItgBVr
         Q2NrPWBq5E5OXyQI2zxnzHI5mTzGoFjf5SyZVmP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0955/1157] ASoC: SOF: ipc-msg-injector: fix copy in sof_msg_inject_ipc4_dfs_write()
Date:   Mon, 15 Aug 2022 20:05:11 +0200
Message-Id: <20220815180517.825168254@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fa9b878ff86f4adccddf62492a5894fbdb04f97d ]

There are two bugs that have to do with when we copy the payload:

	size = simple_write_to_buffer(ipc4_msg->data_ptr,
			      priv->max_msg_size, ppos, buffer,
			      count);

The value of "*ppos" was supposed to be zero but it is
sizeof(ipc4_msg->header_u64) so it will copy the data into the middle of
the "ipc4_msg->data_ptr" buffer instead of to the start.  The second
problem is "buffer" should be "buffer + sizeof(ipc4_msg->header_u64)".

This function is used for fuzz testing so the data is normally random
and this bug likely does not affect anyone very much.

In this context, it's simpler and more appropriate to use copy_from_user()
instead of simple_write_to_buffer() so I have re-written the function.

Fixes: 066c67624d8c ("ASoC: SOF: ipc-msg-injector: Add support for IPC4 messages")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/Ysg1tB2FKLnRMsel@kili
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-client-ipc-msg-injector.c | 29 +++++++++------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/sound/soc/sof/sof-client-ipc-msg-injector.c b/sound/soc/sof/sof-client-ipc-msg-injector.c
index 6bdfa527b7f7..752d5320680f 100644
--- a/sound/soc/sof/sof-client-ipc-msg-injector.c
+++ b/sound/soc/sof/sof-client-ipc-msg-injector.c
@@ -181,7 +181,7 @@ static ssize_t sof_msg_inject_ipc4_dfs_write(struct file *file,
 	struct sof_client_dev *cdev = file->private_data;
 	struct sof_msg_inject_priv *priv = cdev->data;
 	struct sof_ipc4_msg *ipc4_msg = priv->tx_buffer;
-	ssize_t size;
+	size_t data_size;
 	int ret;
 
 	if (*ppos)
@@ -191,25 +191,20 @@ static ssize_t sof_msg_inject_ipc4_dfs_write(struct file *file,
 		return -EINVAL;
 
 	/* copy the header first */
-	size = simple_write_to_buffer(&ipc4_msg->header_u64,
-				      sizeof(ipc4_msg->header_u64),
-				      ppos, buffer, count);
-	if (size < 0)
-		return size;
-	if (size != sizeof(ipc4_msg->header_u64))
+	if (copy_from_user(&ipc4_msg->header_u64, buffer,
+			   sizeof(ipc4_msg->header_u64)))
 		return -EFAULT;
 
-	count -= size;
+	data_size = count - sizeof(ipc4_msg->header_u64);
+	if (data_size > priv->max_msg_size)
+		return -EINVAL;
+
 	/* Copy the payload */
-	size = simple_write_to_buffer(ipc4_msg->data_ptr,
-				      priv->max_msg_size, ppos, buffer,
-				      count);
-	if (size < 0)
-		return size;
-	if (size != count)
+	if (copy_from_user(ipc4_msg->data_ptr,
+			   buffer + sizeof(ipc4_msg->header_u64), data_size))
 		return -EFAULT;
 
-	ipc4_msg->data_size = count;
+	ipc4_msg->data_size = data_size;
 
 	/* Initialize the reply storage */
 	ipc4_msg = priv->rx_buffer;
@@ -221,9 +216,9 @@ static ssize_t sof_msg_inject_ipc4_dfs_write(struct file *file,
 
 	/* return the error code if test failed */
 	if (ret < 0)
-		size = ret;
+		return ret;
 
-	return size;
+	return count;
 };
 
 static int sof_msg_inject_dfs_release(struct inode *inode, struct file *file)
-- 
2.35.1



