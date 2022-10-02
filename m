Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB06A5F2677
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJBWxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJBWxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:53:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D87E3DBDC;
        Sun,  2 Oct 2022 15:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39DF9B80D6C;
        Sun,  2 Oct 2022 22:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D082C43145;
        Sun,  2 Oct 2022 22:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751064;
        bh=10n/miRVfjce6Xcro6e8sn0bMp8ick+Rw7BnsxLGLyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTmSO0HpsKr+zDyri3u+LQ/KlaQtGGWuY46tsuTC6mV/BNq2nE+BaLbsuNi5jgDxe
         X4thVye4LYw7OpKC/kv2KxAJ1tQYFvb5YBRbxqOfAwEiKZyKXQxGz0kXJQWq1VTDcU
         0kJ2og8QnreFF6ewnnih7qrjNbsGwXKKTQLiLrQ6l1lP9O/Y6OHuSrCswSA5mK6TPp
         8qqN+/7lsJO3MslJWRrHxt3K3P0ISDox6XBs+uvpl0eUUC6taUUkjFtYsH6hEr8Kp1
         5t8rggK13G9iGybTMv41vUA5Q9F/ThehmKLH/gtJGYaIPNW7FkokKnEn3pzFK0/sEQ
         CpXzj2mYkqxLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 03/20] firmware: arm_scmi: Harden accesses to the reset domains
Date:   Sun,  2 Oct 2022 18:50:42 -0400
Message-Id: <20221002225100.239217-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
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
index 9bf2478ec6d1..fc6237d6e926 100644
--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -152,8 +152,12 @@ static int scmi_domain_reset(const struct scmi_protocol_handle *ph, u32 domain,
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

