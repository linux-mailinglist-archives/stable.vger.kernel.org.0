Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CA9538085
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiE3OMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239641AbiE3OJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:09:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36B0D19FA;
        Mon, 30 May 2022 06:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3636EB80DB9;
        Mon, 30 May 2022 13:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D088C3411C;
        Mon, 30 May 2022 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918157;
        bh=FXpiOAXaZbLiKNiDcTOuQElJDUuEn+qZXqf2OSRLOuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXVaud/Snjq59svOrWrZ6OkJXRY2APhm1sOUwtagKd9PbkLnf5MCA77K8kPGBxXFH
         mNPl0v9VNq7ycFymaPb7NOPishhLwgBJX3gkhAuC/b5uxgTn2zzxexLyumGLyOUYC0
         PxR5Zl+g/uXkouvrL9SaYvMiDanvPn1h0Ij6thLcckK0P9DGZdGVJ+7eykxYIhvbBH
         OiQrW+rD7ZuFSk0bFn9Bko29SIfz+j8/GGZGV1XKAzWmVvAk+rjHVFq3VWs7Sjz8rf
         5hy7d0MLbszaY9UNHvzrj2FIjiYlHkyLGtIi7bhT8e/5UqkyyNTOQbnVIrHm9D/CiG
         fP0ts3NmM3J+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 081/109] media: cec-adap.c: fix is_configuring state
Date:   Mon, 30 May 2022 09:37:57 -0400
Message-Id: <20220530133825.1933431-81-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
 drivers/media/cec/core/cec-adap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 1f599e300e42..67776a0d31e8 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1272,7 +1272,7 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 		 * While trying to poll the physical address was reset
 		 * and the adapter was unconfigured, so bail out.
 		 */
-		if (!adap->is_configuring)
+		if (adap->phys_addr == CEC_PHYS_ADDR_INVALID)
 			return -EINTR;
 
 		if (err)
@@ -1329,7 +1329,6 @@ static void cec_adap_unconfigure(struct cec_adapter *adap)
 	    adap->phys_addr != CEC_PHYS_ADDR_INVALID)
 		WARN_ON(adap->ops->adap_log_addr(adap, CEC_LOG_ADDR_INVALID));
 	adap->log_addrs.log_addr_mask = 0;
-	adap->is_configuring = false;
 	adap->is_configured = false;
 	cec_flush(adap);
 	wake_up_interruptible(&adap->kthread_waitq);
@@ -1521,9 +1520,10 @@ static int cec_config_thread_func(void *arg)
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

