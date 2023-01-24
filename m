Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1260F679A16
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbjAXNot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbjAXNoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB4A45BC2;
        Tue, 24 Jan 2023 05:43:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEDDAB811E1;
        Tue, 24 Jan 2023 13:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ABBC433B4;
        Tue, 24 Jan 2023 13:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567793;
        bh=Fr8ngUSDZFbNweZe4Xpvn5UQljHV0Y4OKofXPoxRvOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqYUKWCdBVY8caoz5m/GmQvr6hNnUxAxg2oIFDrsIOhJFSHgFsoh0fQ/kWrDrEfJz
         dxZCWIBfaMaIstL7oo+BJ+cG5wC2LjKNlf4bAqxTQrF9hOfBGJPNzxE0Bv9kgnsx97
         OAS4NaFi3Y90UNm3shbsWFWFOTK4lDWZwoTIfea6mS9XQ/kCbZluMYD5/tjLI4XDUk
         UsjY7OSTEvfw3Vap5DnhqjJzYrhpwwHu5/Cc79k6j5Tn+4Cz6qkFGGsLztAUZhQ0k8
         u4GLWMkrDVh0CV8uD8vy5LKQF1Ort3+IJvuCE5eVd+/FhaVWkckiIIUvvznJZAUmmU
         uy9M8mt263uzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 05/14] firmware: arm_scmi: Clear stale xfer->hdr.status
Date:   Tue, 24 Jan 2023 08:42:48 -0500
Message-Id: <20230124134257.637523-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134257.637523-1-sashal@kernel.org>
References: <20230124134257.637523-1-sashal@kernel.org>
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
index a8ff4c9508b7..11842497b226 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -783,6 +783,8 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 			      xfer->hdr.protocol_id, xfer->hdr.seq,
 			      xfer->hdr.poll_completion);
 
+	/* Clear any stale status */
+	xfer->hdr.status = SCMI_SUCCESS;
 	xfer->state = SCMI_XFER_SENT_OK;
 	/*
 	 * Even though spinlocking is not needed here since no race is possible
-- 
2.39.0

