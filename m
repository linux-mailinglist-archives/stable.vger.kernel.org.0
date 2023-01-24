Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0EB6799C0
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbjAXNl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbjAXNlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:41:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F285A4523E;
        Tue, 24 Jan 2023 05:41:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FDEB611E6;
        Tue, 24 Jan 2023 13:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FC1C4339B;
        Tue, 24 Jan 2023 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567709;
        bh=plVLPqyNKrCgUkP+vGqlaiEfLLVEMW02/8pVeTqqtSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S23rUbA8EZrNUno3iAy21PHDbyTnpxJArMK07I8fLyW8hqBichU2k7eyPV7AGcrKt
         EJzzd7biR+fRRc4xzdOrXa7cfXe6Fa8uStsa6uLVsCPhiydrKEY75S+kmJl7IjcExY
         I2R73wc+cxAhJvbiTVlqA9M02Fj9HiqXkvOurOtjtsIxD/Q81Q1e2xyT3+ZUDz+P/3
         D8xItA+FFKX+jt7rbliDCbpMIHdE1VmPfwPrdZD7p/jp+Bvryw2uVC+V+YagOJhJmq
         noWxA1NEaKPZ3KQ703FLgb/U184msWmc6s9foSickyaY6lNyENCxJyO2cfVmwRKxdD
         rkElaTc6tqLmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 05/35] firmware: arm_scmi: Clear stale xfer->hdr.status
Date:   Tue, 24 Jan 2023 08:41:01 -0500
Message-Id: <20230124134131.637036-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit f6ca5059dc0d6608dc46070f48e396d611f240d6 ]

Stale error status reported from a previous message transaction must be
cleared before starting a new transaction to avoid being confusingly
reported in the following SCMI message dump traces.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222183823.518856-2-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f818d00bb2c6..ffdad59ec81f 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -910,6 +910,8 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 			      xfer->hdr.protocol_id, xfer->hdr.seq,
 			      xfer->hdr.poll_completion);
 
+	/* Clear any stale status */
+	xfer->hdr.status = SCMI_SUCCESS;
 	xfer->state = SCMI_XFER_SENT_OK;
 	/*
 	 * Even though spinlocking is not needed here since no race is possible
-- 
2.39.0

