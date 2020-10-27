Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93380299F3A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438666AbgJ0AGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438158AbgJ0AFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:05:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61F42087C;
        Tue, 27 Oct 2020 00:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757108;
        bh=0WPl1MyFeXwDNAOJwHf2dIt0E01BWkqsAC3b9Kikm6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1sqEy4kWU9tZoiuOnyICsnuId/aOsTsiUdbL5MjegRYs2uofRrJQZarOvs4n9dN4
         9OYRp39R+us6+rjg7ZJEOIuiDtMfn72HGJdBrII0Hk66KudGGffTXVI4IeV9VKtZob
         xwBVmjWCY+NrChkGTtvE6xbzqEL/w4WEGM0UzbXw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Lew <clew@codeaurora.org>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Deepak Kumar Singh <deesin@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 45/60] rpmsg: glink: Use complete_all for open states
Date:   Mon, 26 Oct 2020 20:04:00 -0400
Message-Id: <20201027000415.1026364-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

[ Upstream commit 4fcdaf6e28d11e2f3820d54dd23cd12a47ddd44e ]

The open_req and open_ack completion variables are the state variables
to represet a remote channel as open. Use complete_all so there are no
races with waiters and using completion_done.

Signed-off-by: Chris Lew <clew@codeaurora.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Deepak Kumar Singh <deesin@codeaurora.org>
Link: https://lore.kernel.org/r/1593017121-7953-2-git-send-email-deesin@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index facc577ab0acc..a755f85686e53 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -970,7 +970,7 @@ static int qcom_glink_rx_open_ack(struct qcom_glink *glink, unsigned int lcid)
 		return -EINVAL;
 	}
 
-	complete(&channel->open_ack);
+	complete_all(&channel->open_ack);
 
 	return 0;
 }
@@ -1178,7 +1178,7 @@ static int qcom_glink_announce_create(struct rpmsg_device *rpdev)
 	__be32 *val = defaults;
 	int size;
 
-	if (glink->intentless)
+	if (glink->intentless || !completion_done(&channel->open_ack))
 		return 0;
 
 	prop = of_find_property(np, "qcom,intents", NULL);
@@ -1413,7 +1413,7 @@ static int qcom_glink_rx_open(struct qcom_glink *glink, unsigned int rcid,
 	channel->rcid = ret;
 	spin_unlock_irqrestore(&glink->idr_lock, flags);
 
-	complete(&channel->open_req);
+	complete_all(&channel->open_req);
 
 	if (create_device) {
 		rpdev = kzalloc(sizeof(*rpdev), GFP_KERNEL);
-- 
2.25.1

