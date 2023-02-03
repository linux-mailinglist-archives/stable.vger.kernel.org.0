Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BB5689682
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjBCKZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjBCKYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:24:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D406E2D176
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05617B82A5F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F531C433EF;
        Fri,  3 Feb 2023 10:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419837;
        bh=Fr8ngUSDZFbNweZe4Xpvn5UQljHV0Y4OKofXPoxRvOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxghTJp1/86+MStRi5r88OXUxE5nKpa0WQqS3xVVbiwOdVi9c7SzDrQXhAjNTBcg4
         J5EqGPr/OW/NUXRo8DW/cQzTOoD6Rpdbtr/RUH70HWQ+GkimqrH5tS5SZid9BFHl3A
         hjl3zSC/f3nHYfj6jpSf/oeXe455sR/AQoFlGxug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/20] firmware: arm_scmi: Clear stale xfer->hdr.status
Date:   Fri,  3 Feb 2023 11:13:32 +0100
Message-Id: <20230203101008.229256403@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



