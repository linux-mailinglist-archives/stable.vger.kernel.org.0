Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009EC5F260B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJBWtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiJBWta (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:49:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E09133E31;
        Sun,  2 Oct 2022 15:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC491B80D99;
        Sun,  2 Oct 2022 22:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30AAC433C1;
        Sun,  2 Oct 2022 22:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664750967;
        bh=3U8+taxfW3TreG1faUr7vzxQduJVn6HmKDgTNecnz08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0FfG8oNEh8zR6RIN1MplTGgTo5RnQihJpPfoJ09KRkYSd+0gviykfV7TC7Q7oIds
         1gmQ1LEtgw3BD6rFg0tcX6OlksKusPrFh9l1HTYfzbEcz8arEbQJacgmdTugV/elRS
         QmjGZ0mtPO1GcYYeMUBVIS8abGIxQj651MTITdxZCCWoDJ14zsbx3bCLVUHJJvQgPN
         KQOLI2YRwryuJAJ6JdTq+x5nJ2VLDEowvmjMlHxqn5/oQutfcyklwDux7brh8c0Egt
         zguIsMWbqCh8a1be7u4FpQsiNccvNNkaDdbLI38MU2sDfSWhPCsnwwZkFWM1mtIK0V
         gzWrcdkd3i71g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 03/29] firmware: arm_scmi: Harden accesses to the reset domains
Date:   Sun,  2 Oct 2022 18:48:56 -0400
Message-Id: <20221002224922.238837-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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

[ Upstream commit e9076ffbcaed5da6c182b144ef9f6e24554af268 ]

Accessing reset domains descriptors by the index upon the SCMI drivers
requests through the SCMI reset operations interface can potentially
lead to out-of-bound violations if the SCMI driver misbehave.

Add an internal consistency check before any such domains descriptors
accesses.

Link: https://lore.kernel.org/r/20220817172731.1185305-5-cristian.marussi@arm.com
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/reset.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/reset.c b/drivers/firmware/arm_scmi/reset.c
index 673f3eb498f4..b0494165b1cb 100644
--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -166,8 +166,12 @@ static int scmi_domain_reset(const struct scmi_protocol_handle *ph, u32 domain,
 	struct scmi_xfer *t;
 	struct scmi_msg_reset_domain_reset *dom;
 	struct scmi_reset_info *pi = ph->get_priv(ph);
-	struct reset_dom_info *rdom = pi->dom_info + domain;
+	struct reset_dom_info *rdom;
 
+	if (domain >= pi->num_domains)
+		return -EINVAL;
+
+	rdom = pi->dom_info + domain;
 	if (rdom->async_reset)
 		flags |= ASYNCHRONOUS_RESET;
 
-- 
2.35.1

