Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2DE148406
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391601AbgAXLkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391294AbgAXLXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:14 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB89A214DB;
        Fri, 24 Jan 2020 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864993;
        bh=QuLnnKDn/OU0rM9V+Dnb0xKOJJwr2DKUZ0JuC/ZyCow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/M+/4+mbLbWH6urbO6wwEsnBFbE3qP6EPfD+VBRC35cLmkEd9b/Tue69AKnUne2m
         lHCdggEQqJqzhOqDxPSHSpBg+bB5H1KzgQ/Fqc2aH3hvwaHZrKyTKxS4GjaqSHqRfx
         jDRfy8iXNBOT2KdhPbiPHRFQioyY7P6sM2P6Qe8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 423/639] firmware: arm_scmi: update rate_discrete in clock_describe_rates_get
Date:   Fri, 24 Jan 2020 10:29:53 +0100
Message-Id: <20200124093140.036895698@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c0759b9b5d411ab27c479125cee9bae391a96436 ]

The boolean rate_discrete needs to be assigned to clk->rate_discrete,
so that clock driver can distinguish between the continuous range and
discrete rates. It uses this in scmi_clk_round_rate could get the
rounded value if it's a continuous range.

Fixes: 5f6c6430e904 ("firmware: arm_scmi: add initial support for clock protocol")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
[sudeep.holla: updated commit message]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/clock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 30fc04e284312..0a194af924385 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -185,6 +185,8 @@ scmi_clock_describe_rates_get(const struct scmi_handle *handle, u32 clk_id,
 	if (rate_discrete)
 		clk->list.num_rates = tot_rate_cnt;
 
+	clk->rate_discrete = rate_discrete;
+
 err:
 	scmi_xfer_put(handle, t);
 	return ret;
-- 
2.20.1



