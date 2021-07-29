Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030BD3DA4D9
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbhG2N4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237933AbhG2N4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A022360F48;
        Thu, 29 Jul 2021 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627566989;
        bh=z9fgw4RdACJbMctbCl+ANgw/8SM3JA0y2OW3YTUL4h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdpZMA/cgMb6IGEvKgH8Z/C/zXwkk2Nwwvhcf1QAX2mhTtmfdpmIm1DDWRJrGrRxe
         91TFkPPzcosC2JPrXeK4J80M1Qp2+wR/T++eJuoJWxTBDO2d1ElYg57aKnO3r2+yFR
         ca4aC2Ef//7IMIT0hsGu5fuZqq1DLsgfjS+zxO/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/17] firmware: arm_scmi: Fix range check for the maximum number of pending messages
Date:   Thu, 29 Jul 2021 15:54:16 +0200
Message-Id: <20210729135137.740591597@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
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
index 081fbe28da4b..af5139eb96b5 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -629,8 +629,9 @@ static int scmi_xfer_info_init(struct scmi_info *sinfo)
 	struct scmi_xfers_info *info = &sinfo->minfo;
 
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



