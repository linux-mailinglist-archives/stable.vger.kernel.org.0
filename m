Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49C53D32B6
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhGWDSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233871AbhGWDRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356EB60EE6;
        Fri, 23 Jul 2021 03:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012687;
        bh=ymQYYK6kNi6/xyFrlemIO1/cHMJSSsn/2zsfsjw+BuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VztCYIX9OXapA5ZjWKFAyhSN/aBS6KdNPG6djiEC+w1hT2N2iV6OKVvt2HQI1f/d+
         5GOFTRmV37Egf7bPy19P+hU2MolSMLeRmlZSmoVN44KjdYqj7HL92MaMpRJLmUO3Py
         kiC1TjhT2uyrQmUlEmI8of5BmBCZjfiTEHGH5KYR5WxVaxUy1oPdXaS+GIEaA3xzG0
         3VIfNavY/JruQ8FSfzf20XLu3zLIsJYDkMeS+1QoZC2axer3r4VVPwckH8ZytA2iZb
         afSKYzpW7Z39E3DN7954eSzYD0+mqFCRMV7IpyMGru11fWohP/k3sa1YdRFd2EyHwU
         Nq/a1gR87MvGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 13/17] firmware: arm_scmi: Fix range check for the maximum number of pending messages
Date:   Thu, 22 Jul 2021 23:57:44 -0400
Message-Id: <20210723035748.531594-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035748.531594-1-sashal@kernel.org>
References: <20210723035748.531594-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit bdb8742dc6f7c599c3d61959234fe4c23638727b ]

SCMI message headers carry a sequence number and such field is sized to
allow for MSG_TOKEN_MAX distinct numbers; moreover zero is not really an
acceptable maximum number of pending in-flight messages.

Fix accordingly the checks performed on the value exported by transports
in scmi_desc.max_msg

Link: https://lore.kernel.org/r/20210712141833.6628-3-cristian.marussi@arm.com
Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
[sudeep.holla: updated the patch title and error message]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index c396b1d9a3b7..49f4fe575605 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -611,8 +611,9 @@ static int __scmi_xfer_info_init(struct scmi_info *sinfo,
 	const struct scmi_desc *desc = sinfo->desc;
 
 	/* Pre-allocated messages, no more than what hdr.seq can support */
-	if (WARN_ON(desc->max_msg >= MSG_TOKEN_MAX)) {
-		dev_err(dev, "Maximum message of %d exceeds supported %ld\n",
+	if (WARN_ON(!desc->max_msg || desc->max_msg > MSG_TOKEN_MAX)) {
+		dev_err(dev,
+			"Invalid maximum messages %d, not in range [1 - %lu]\n",
 			desc->max_msg, MSG_TOKEN_MAX);
 		return -EINVAL;
 	}
-- 
2.30.2

