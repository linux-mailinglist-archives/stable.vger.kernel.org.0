Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37412538310
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240692AbiE3O3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242006AbiE3OSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:18:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6E19D07A;
        Mon, 30 May 2022 06:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8FD60EC3;
        Mon, 30 May 2022 13:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBECFC36AE5;
        Mon, 30 May 2022 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918529;
        bh=LwQYWt8RcYawY9dcDrj6e1/FgVm0e/k1MIM239Db11s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWXn7kJW6G+TW3X6dhuLrPkJGcWjm+W/x8ULVRhzuPnAPzHRTTNHHR72hYt20M8TE
         84C30Ms1HyZlrjCTLrfRseOe+6O1vUVwYOJnGcAEpfn/NqvLwPnWZGjnCqsG2vI3S3
         wMgQOacex0VRNP/c/MB5+3OI2PsdQrjsDALtxU81yQzamsif7Qsu4o3sCj2LXvtdkI
         68/ZMmUEvO0VIRCmQmKdaDQeJvb1zSotSBc4MLCqpvw/e5Tov4kWqr5qMkUj/vHvCn
         0drEMEcadg2w9DPuUsnLH3ETbKdk/DnZNfhW6FhJ+SMy0U/NQiILYl/yfzYo4I4bCm
         F5o8eNQnRLusA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/55] media: cec-adap.c: fix is_configuring state
Date:   Mon, 30 May 2022 09:46:49 -0400
Message-Id: <20220530134701.1935933-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 59267fc34f4900dcd2ec3295f6be04b79aee2186 ]

If an adapter is trying to claim a free logical address then it is
in the 'is_configuring' state. If during that process the cable is
disconnected (HPD goes low, which in turn invalidates the physical
address), then cec_adap_unconfigure() is called, and that set the
is_configuring boolean to false, even though the thread that's
trying to claim an LA is still running.

Don't touch the is_configuring bool in cec_adap_unconfigure(), it
will eventually be cleared by the thread. By making that change
the cec_config_log_addr() function also had to change: it was
aborting if is_configuring became false (since that is what
cec_adap_unconfigure() did), but that no longer works. Instead
check if the physical address is invalid. That is a much
more appropriate check anyway.

This fixes a bug where the the adapter could be disabled even
though the device was still configuring. This could cause POLL
transmits to time out.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-adap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 56857ac0a0be..c665f7d20c44 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1263,7 +1263,7 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 		 * While trying to poll the physical address was reset
 		 * and the adapter was unconfigured, so bail out.
 		 */
-		if (!adap->is_configuring)
+		if (adap->phys_addr == CEC_PHYS_ADDR_INVALID)
 			return -EINTR;
 
 		if (err)
@@ -1321,7 +1321,6 @@ static void cec_adap_unconfigure(struct cec_adapter *adap)
 	    adap->phys_addr != CEC_PHYS_ADDR_INVALID)
 		WARN_ON(adap->ops->adap_log_addr(adap, CEC_LOG_ADDR_INVALID));
 	adap->log_addrs.log_addr_mask = 0;
-	adap->is_configuring = false;
 	adap->is_configured = false;
 	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
 	cec_flush(adap);
@@ -1514,9 +1513,10 @@ static int cec_config_thread_func(void *arg)
 	for (i = 0; i < las->num_log_addrs; i++)
 		las->log_addr[i] = CEC_LOG_ADDR_INVALID;
 	cec_adap_unconfigure(adap);
+	adap->is_configuring = false;
 	adap->kthread_config = NULL;
-	mutex_unlock(&adap->lock);
 	complete(&adap->config_completion);
+	mutex_unlock(&adap->lock);
 	return 0;
 }
 
-- 
2.35.1

