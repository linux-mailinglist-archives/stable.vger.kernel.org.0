Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B023D328B
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhGWDRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233642AbhGWDRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BECB460EC0;
        Fri, 23 Jul 2021 03:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012662;
        bh=uIO2cszPdhBYJGfbs19fiW03dSSWxLg/CsSfze1N1yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPxjsF1vcccZIrCQFb6Y7egxFFz/WIvBMprja9bqqZS/WVFTuDiygzxhUdN9ek03O
         izugaPgAg985K7si2P3DMyUKzmQtBjTdvCilxfESwyriqq6eqT2aJ50taQ4A53UtMt
         CgKG5cQbIU1d2JZ4HMjPPFpc3i9I6nQiWBRCpTOKL8Ik/7hqXnCaynEmJDF/hSDFB5
         loAZ1W9vwKwp2NpkUxAR2pHxm0JxyGPp0TEEPmP12ch4n/flF0eF/2SiWG8f2FdL9C
         35Rmared8PiJNoJDxUthmu8Ohh/3vzE5HzcaS3K+Dd0vJ9z7wnBNkF9Ie7ssJWTpZc
         BO3d8yf50YQxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 15/19] firmware: arm_scmi: Fix range check for the maximum number of pending messages
Date:   Thu, 22 Jul 2021 23:57:16 -0400
Message-Id: <20210723035721.531372-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035721.531372-1-sashal@kernel.org>
References: <20210723035721.531372-1-sashal@kernel.org>
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
index ce81ed053876..b342490e032b 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1022,8 +1022,9 @@ static int __scmi_xfer_info_init(struct scmi_info *sinfo,
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

