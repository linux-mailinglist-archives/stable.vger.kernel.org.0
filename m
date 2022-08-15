Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32267594A17
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355316AbiHOXzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355528AbiHOXwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0BDC59D8;
        Mon, 15 Aug 2022 13:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA92B80EB1;
        Mon, 15 Aug 2022 20:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488C6C433C1;
        Mon, 15 Aug 2022 20:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594625;
        bh=ybd09Vc2nJeq4SVb7k1C88wFe9kRvGJKQUI0L0zWLYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcCUYN+QAmINq7foh7o7dF8WJLQP0Ue4PKBmfZ3+T5A/CbC1TzZF+4DxF9bobwAsN
         KVoUNtGQAGpLt78n4sQ4ahtgky7MWAGmtz7S1jzqNgYUx7vAw1nNZ/4CIa8Zu6P1GS
         XAxRoOtM0fBV5T/zB6udoAzFQyWBmLNKQf2GH8r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0506/1157] wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()
Date:   Mon, 15 Aug 2022 19:57:42 +0200
Message-Id: <20220815180459.935374948@linuxfoundation.org>
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

[ Upstream commit 7a4836560a6198d245d5732e26f94898b12eb760 ]

The simple_write_to_buffer() function will succeed if even a single
byte is initialized.  However, we need to initialize the whole buffer
to prevent information leaks.  Just use memdup_user().

Fixes: ff974e408334 ("wil6210: debugfs interface to send raw WMI command")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/Ysg14NdKAZF/hcNG@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 64d6c98174c8..fe84362718de 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1012,18 +1012,12 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 	u16 cmdid;
 	int rc, rc1;
 
-	if (cmdlen < 0)
+	if (cmdlen < 0 || *ppos != 0)
 		return -EINVAL;
 
-	wmi = kmalloc(len, GFP_KERNEL);
-	if (!wmi)
-		return -ENOMEM;
-
-	rc = simple_write_to_buffer(wmi, len, ppos, buf, len);
-	if (rc < 0) {
-		kfree(wmi);
-		return rc;
-	}
+	wmi = memdup_user(buf, len);
+	if (IS_ERR(wmi))
+		return PTR_ERR(wmi);
 
 	cmd = (cmdlen > 0) ? &wmi[1] : NULL;
 	cmdid = le16_to_cpu(wmi->command_id);
-- 
2.35.1



