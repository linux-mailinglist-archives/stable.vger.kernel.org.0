Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269B75492E3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355649AbiFMLmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355710AbiFMLk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:40:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2C02DD42;
        Mon, 13 Jun 2022 03:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8803B612C9;
        Mon, 13 Jun 2022 10:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1FEC341C5;
        Mon, 13 Jun 2022 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117408;
        bh=JPc5ATt74aBSyqf5YJ+9MP8PPRtJCzzOXwDCZkRdpo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pq99FAhiiSezXGIELlPa6aRaiDLHUh8y8Nz4u8jEVgJ6GHrr5VSBdFLrQUd0JRRkx
         z4DALiDxMR4tPZ3lWNAK5fhCPhWe74LNvADDbCEJ2c++t478RO8up4jLew0Lm19aft
         628CLZEgqblkPJOBk9ITtLrMJZXed2Nq40f1Mcp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/287] media: cec-adap.c: fix is_configuring state
Date:   Mon, 13 Jun 2022 12:07:39 +0200
Message-Id: <20220613094924.929317257@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
 drivers/media/cec/cec-adap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 5eeadab15a5f..a42043379d67 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1218,7 +1218,7 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 		 * While trying to poll the physical address was reset
 		 * and the adapter was unconfigured, so bail out.
 		 */
-		if (!adap->is_configuring)
+		if (adap->phys_addr == CEC_PHYS_ADDR_INVALID)
 			return -EINTR;
 
 		if (err)
@@ -1276,7 +1276,6 @@ static void cec_adap_unconfigure(struct cec_adapter *adap)
 	    adap->phys_addr != CEC_PHYS_ADDR_INVALID)
 		WARN_ON(adap->ops->adap_log_addr(adap, CEC_LOG_ADDR_INVALID));
 	adap->log_addrs.log_addr_mask = 0;
-	adap->is_configuring = false;
 	adap->is_configured = false;
 	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
 	cec_flush(adap);
@@ -1469,9 +1468,10 @@ static int cec_config_thread_func(void *arg)
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



