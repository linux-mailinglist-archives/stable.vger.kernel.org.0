Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD0068D76F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjBGM7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjBGM7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC307DB1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87734B8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAA3C433D2;
        Tue,  7 Feb 2023 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774778;
        bh=Go9wbQRrGvzCTM/B46k+Kt0HKtfLSptJFlXj6VRU3cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bq4CJuF+3HnQdh1G4piFSfRvf9UHAThYbySXZ99Ce6AIfF999GcnKR4qRW/aQPxqe
         pcS5+VBnmeIP8zp7Bw5GLB9Cq/tjDizEzKALSmVwRymcuI/rpzdPP8m2ld7PD6JlKG
         YToMWC2iNWaoSjhdgpljn+51P65re/l41y+oarVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/208] WRITE is "data source", not destination...
Date:   Tue,  7 Feb 2023 13:54:45 +0100
Message-Id: <20230207125635.726813931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 974c36fb828aeae7b4f9063f94860ae6c5633efd ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6dd88fd59da8 ("vhost-scsi: unbreak any layout for response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-sbefifo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index 5f93a53846aa..efd4942aa043 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -659,7 +659,7 @@ static void sbefifo_collect_async_ffdc(struct sbefifo *sbefifo)
 	}
         ffdc_iov.iov_base = ffdc;
 	ffdc_iov.iov_len = SBEFIFO_MAX_FFDC_SIZE;
-        iov_iter_kvec(&ffdc_iter, WRITE, &ffdc_iov, 1, SBEFIFO_MAX_FFDC_SIZE);
+        iov_iter_kvec(&ffdc_iter, READ, &ffdc_iov, 1, SBEFIFO_MAX_FFDC_SIZE);
 	cmd[0] = cpu_to_be32(2);
 	cmd[1] = cpu_to_be32(SBEFIFO_CMD_GET_SBE_FFDC);
 	rc = sbefifo_do_command(sbefifo, cmd, 2, &ffdc_iter);
@@ -756,7 +756,7 @@ int sbefifo_submit(struct device *dev, const __be32 *command, size_t cmd_len,
 	rbytes = (*resp_len) * sizeof(__be32);
 	resp_iov.iov_base = response;
 	resp_iov.iov_len = rbytes;
-        iov_iter_kvec(&resp_iter, WRITE, &resp_iov, 1, rbytes);
+        iov_iter_kvec(&resp_iter, READ, &resp_iov, 1, rbytes);
 
 	/* Perform the command */
 	rc = mutex_lock_interruptible(&sbefifo->lock);
@@ -839,7 +839,7 @@ static ssize_t sbefifo_user_read(struct file *file, char __user *buf,
 	/* Prepare iov iterator */
 	resp_iov.iov_base = buf;
 	resp_iov.iov_len = len;
-	iov_iter_init(&resp_iter, WRITE, &resp_iov, 1, len);
+	iov_iter_init(&resp_iter, READ, &resp_iov, 1, len);
 
 	/* Perform the command */
 	rc = mutex_lock_interruptible(&sbefifo->lock);
-- 
2.39.0



