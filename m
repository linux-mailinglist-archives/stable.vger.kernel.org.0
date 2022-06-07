Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCBA540546
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346090AbiFGRYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346254AbiFGRXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:23:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2844F109197;
        Tue,  7 Jun 2022 10:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFE79B81F38;
        Tue,  7 Jun 2022 17:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39842C385A5;
        Tue,  7 Jun 2022 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622494;
        bh=mQu+7jJPIF9TEi1yf1eSXdv0q/LGMuG0jvAGx/7bRBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+RsfxEvVCyFdlWQz6ui8SX+Tf7cuZOfva7jt/0XGAxM4H9E6JoaOljimEZojLjVH
         B8VedzosEcbNVOAgywSSFAhtD11OT1PthNGxdiFCzZxBejU8yqymLJwaHeIKORcnBX
         sHii1enA/4L6y6jZk0FTcT6Akbk10dNkXecbgwGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/452] media: cec-adap.c: fix is_configuring state
Date:   Tue,  7 Jun 2022 18:58:57 +0200
Message-Id: <20220607164910.936627651@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 2e5698fbc3a8..e23aa608f66f 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1271,7 +1271,7 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 		 * While trying to poll the physical address was reset
 		 * and the adapter was unconfigured, so bail out.
 		 */
-		if (!adap->is_configuring)
+		if (adap->phys_addr == CEC_PHYS_ADDR_INVALID)
 			return -EINTR;
 
 		if (err)
@@ -1328,7 +1328,6 @@ static void cec_adap_unconfigure(struct cec_adapter *adap)
 	    adap->phys_addr != CEC_PHYS_ADDR_INVALID)
 		WARN_ON(adap->ops->adap_log_addr(adap, CEC_LOG_ADDR_INVALID));
 	adap->log_addrs.log_addr_mask = 0;
-	adap->is_configuring = false;
 	adap->is_configured = false;
 	cec_flush(adap);
 	wake_up_interruptible(&adap->kthread_waitq);
@@ -1520,9 +1519,10 @@ static int cec_config_thread_func(void *arg)
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



