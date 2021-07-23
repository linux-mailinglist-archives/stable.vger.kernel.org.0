Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8BF3D32C3
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhGWDSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234180AbhGWDRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5003760F38;
        Fri, 23 Jul 2021 03:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012709;
        bh=ndx/mOGnLOhap9xANN6K1vSFYUJd4L64EZ5R6OEr5Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtPhaU+udVarx//W88xbO13IXlo5re2XIEIYoeHZEdDV2PZgUoEMQdeXgXMvKKZr2
         3gObNV3sov7n514NzcL0dRX1xzsifq/Ee8YCbMQ0b4uXaKw4B0q7Jvr2bcoJm7uXjf
         8mGQVY2BTiyMN5pV2DyJRceULv8HpJzauOMci2ZZ+3UubfT/pzjUXKKNRmaVep+lQR
         Ihc26T0IMAxbBaSBlSY9mtuzA0jnoGaoVmTiXWJCmYB3oFKN9fXWR18U7jO9Prm3+C
         Md+xAlwVwPpJhzq01GxrXS8VSyfJGBemJD4kF4qJFTDqRY3v5rwWYTs+FkPcaSIdWw
         IL5VddwfFPPTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 10/14] firmware: arm_scmi: Fix range check for the maximum number of pending messages
Date:   Thu, 22 Jul 2021 23:58:09 -0400
Message-Id: <20210723035813.531837-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035813.531837-1-sashal@kernel.org>
References: <20210723035813.531837-1-sashal@kernel.org>
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
index 629f57795a9b..551672aecd2c 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -690,8 +690,9 @@ static int scmi_xfer_info_init(struct scmi_info *sinfo)
 	struct scmi_xfers_info *info = &sinfo->tx_minfo;
 
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

