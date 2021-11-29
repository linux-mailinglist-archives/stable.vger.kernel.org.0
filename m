Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15E461F02
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380072AbhK2Smk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:42:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45756 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357338AbhK2Ski (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A92A7B815C9;
        Mon, 29 Nov 2021 18:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63EEC53FC7;
        Mon, 29 Nov 2021 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211036;
        bh=tD6umhopPGw4KbA8zw9MLKRFX0kf+DTQMHPAbZx0Bus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkbTZ2ujmz1FT17z3bjPUE9vE1N9oudsIRFwt1loQmNJ8f0v6jyZJCd/BZFMiL5I6
         +R9HJrvUiQ0GMzlfw4DyIfIT2aVcOHuGdJM4LU9eI0c6qIG1pXQ2RcGKorDnxCSfAl
         V1oK47i2/rbF1eCne9tt/2jpd9HVw5MHv3qp+C1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/179] firmware: arm_scmi: Fix base agent discover response
Date:   Mon, 29 Nov 2021 19:17:55 +0100
Message-Id: <20211129181721.609516599@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit d1cbd9e0f7e51ae8e3638a36ba884fdbb2fc967e ]

According to scmi specification, the response of the discover agent request
is made of:
- int32 status
- uint32 agent_id
- uint8 name[16]

but the current implementation doesn't take into account the agent_id field
and only allocates a rx buffer of SCMI_MAX_STR_SIZE length

Allocate the correct length for rx buffer and copy the name from the
correct offset in the response.

While no error were returned until v5.15, v5.16-rc1 fails with virtio_scmi
transport channel:

 | arm-scmi firmware:scmi0: SCMI Notifications - Core Enabled.
 | arm-scmi firmware:scmi0: SCMI Protocol v2.0 'Linaro:PMWG' Firmware version 0x2090000
 | scmi-virtio virtio0: tx:used len 28 is larger than in buflen 24

Link: https://lore.kernel.org/r/20211117081856.9932-1-vincent.guittot@linaro.org
Fixes: b6f20ff8bd94 ("firmware: arm_scmi: add common infrastructure and support for base protocol")
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/base.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index de416f9e79213..f5219334fd3a5 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -34,6 +34,12 @@ struct scmi_msg_resp_base_attributes {
 	__le16 reserved;
 };
 
+struct scmi_msg_resp_base_discover_agent {
+	__le32 agent_id;
+	u8 name[SCMI_MAX_STR_SIZE];
+};
+
+
 struct scmi_msg_base_error_notify {
 	__le32 event_control;
 #define BASE_TP_NOTIFY_ALL	BIT(0)
@@ -225,18 +231,21 @@ static int scmi_base_discover_agent_get(const struct scmi_protocol_handle *ph,
 					int id, char *name)
 {
 	int ret;
+	struct scmi_msg_resp_base_discover_agent *agent_info;
 	struct scmi_xfer *t;
 
 	ret = ph->xops->xfer_get_init(ph, BASE_DISCOVER_AGENT,
-				      sizeof(__le32), SCMI_MAX_STR_SIZE, &t);
+				      sizeof(__le32), sizeof(*agent_info), &t);
 	if (ret)
 		return ret;
 
 	put_unaligned_le32(id, t->tx.buf);
 
 	ret = ph->xops->do_xfer(ph, t);
-	if (!ret)
-		strlcpy(name, t->rx.buf, SCMI_MAX_STR_SIZE);
+	if (!ret) {
+		agent_info = t->rx.buf;
+		strlcpy(name, agent_info->name, SCMI_MAX_STR_SIZE);
+	}
 
 	ph->xops->xfer_put(ph, t);
 
-- 
2.33.0



