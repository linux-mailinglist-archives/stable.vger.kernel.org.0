Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66183CE41F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347774AbhGSPmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349573AbhGSPgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AC06606A5;
        Mon, 19 Jul 2021 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711399;
        bh=XxzsSAGT5XBhcastd2f42P6HDuqOoGveJIdex9VjQdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYOVyluaFEuVyGTPBGRAERSRm18qUqwHgorkmadxeWjSAiMCHlAVy3h/R004/VKkZ
         n7owoAS2fspwIDcmXpjEryZMIEQUSNA534uMIED993LDRVWedxD5BOMoa/Hx63PZta
         Gg+okp7wmzQgYpX9500tr7MnNGh/2B05zV04k4jQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 312/351] firmware: arm_scmi: Add delayed response status check
Date:   Mon, 19 Jul 2021 16:54:18 +0200
Message-Id: <20210719144955.377101780@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit f1748b1ee1fa0fd1a074504045b530b62f949188 ]

A successfully received delayed response could anyway report a failure at
the protocol layer in the message status field.

Add a check also for this error condition.

Link: https://lore.kernel.org/r/20210608103056.3388-1-cristian.marussi@arm.com
Fixes: 58ecdf03dbb9 ("firmware: arm_scmi: Add support for asynchronous commands and delayed response")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 5e8e9337adc7..c2983ed53494 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -517,8 +517,12 @@ static int do_xfer_with_response(const struct scmi_protocol_handle *ph,
 	xfer->async_done = &async_response;
 
 	ret = do_xfer(ph, xfer);
-	if (!ret && !wait_for_completion_timeout(xfer->async_done, timeout))
-		ret = -ETIMEDOUT;
+	if (!ret) {
+		if (!wait_for_completion_timeout(xfer->async_done, timeout))
+			ret = -ETIMEDOUT;
+		else if (xfer->hdr.status)
+			ret = scmi_to_linux_errno(xfer->hdr.status);
+	}
 
 	xfer->async_done = NULL;
 	return ret;
-- 
2.30.2



