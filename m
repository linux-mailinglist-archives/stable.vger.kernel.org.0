Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07F55EA45F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbiIZLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiIZLoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:44:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D426472B5D;
        Mon, 26 Sep 2022 03:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54D90B802C5;
        Mon, 26 Sep 2022 10:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D88C433D7;
        Mon, 26 Sep 2022 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189192;
        bh=+H+3e6MavXuunQEspWLbj9AiqmKe3ZMHaTE84jFSCDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnCIi6URDlBnYO1VALuZUGVmWoe97NcCm1tt/yA4a6OE7wIwGhch9RTDZf1XJFH+B
         NXB5Ij6irR8d29jSDOVhg4Y8H+X/GRw1RE6TXFPnL6VdOHtReHI9/kZrP5QTO7/Y6D
         1kkdf0+Oijd1VH5mRbfh7SOdgCdZJw1LVIq9NOpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 072/207] firmware: arm_scmi: Fix the asynchronous reset requests
Date:   Mon, 26 Sep 2022 12:11:01 +0200
Message-Id: <20220926100809.810922623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit b75c83d9b961fd3abf7310f8d36d5e6e9f573efb ]

SCMI Reset protocol specification allows the asynchronous reset request
only when an autonomous reset action is specified. Reset requests based
on explicit assert/deassert of signals should not be served
asynchronously.

Current implementation will instead issue an asynchronous request in any
case, as long as the reset domain had advertised to support asynchronous
resets.

Avoid requesting the asynchronous resets when the reset action is not
of the autonomous type, even if the target reset domain does, in general,
support the asynchronous requests.

Link: https://lore.kernel.org/r/20220817172731.1185305-6-cristian.marussi@arm.com
Fixes: 95a15d80aa0d ("firmware: arm_scmi: Add RESET protocol in SCMI v2.0")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/reset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/reset.c b/drivers/firmware/arm_scmi/reset.c
index b0494165b1cb..e9afa8cab730 100644
--- a/drivers/firmware/arm_scmi/reset.c
+++ b/drivers/firmware/arm_scmi/reset.c
@@ -172,7 +172,7 @@ static int scmi_domain_reset(const struct scmi_protocol_handle *ph, u32 domain,
 		return -EINVAL;
 
 	rdom = pi->dom_info + domain;
-	if (rdom->async_reset)
+	if (rdom->async_reset && flags & AUTONOMOUS_RESET)
 		flags |= ASYNCHRONOUS_RESET;
 
 	ret = ph->xops->xfer_get_init(ph, RESET, sizeof(*dom), 0, &t);
@@ -184,7 +184,7 @@ static int scmi_domain_reset(const struct scmi_protocol_handle *ph, u32 domain,
 	dom->flags = cpu_to_le32(flags);
 	dom->reset_state = cpu_to_le32(state);
 
-	if (rdom->async_reset)
+	if (flags & ASYNCHRONOUS_RESET)
 		ret = ph->xops->do_xfer_with_response(ph, t);
 	else
 		ret = ph->xops->do_xfer(ph, t);
-- 
2.35.1



