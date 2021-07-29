Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFDF3DA4FF
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhG2N5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238020AbhG2N5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E47860F42;
        Thu, 29 Jul 2021 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567036;
        bh=gu6d9Us+WhzE3l0gwrmXsYoZU1puGJK2+pcE0jW2/ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmb/Mnbufk92Y8uIY7vpgS/zOSnKS+RAbiXY9KZ+HNjX+ZV0w9f66Ve9OxH/Vz82t
         aigSnRhM0Xh7+gtHfcfuwh8leq90b60uRwLG/V9RgyIt2iNRQlQcrceB7Ux+O8LjtE
         rargmty2XNWTLGaxyyiTCXBsyrXB0lQGU54aX5cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/21] firmware: arm_scmi: Fix range check for the maximum number of pending messages
Date:   Thu, 29 Jul 2021 15:54:23 +0200
Message-Id: <20210729135143.427393872@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ba2e18d9e0e4..48e6e2b48924 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -694,8 +694,9 @@ static int scmi_xfer_info_init(struct scmi_info *sinfo)
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



